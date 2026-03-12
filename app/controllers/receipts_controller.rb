class ReceiptsController < ApplicationController
  require "tempfile"

  before_action :set_receipt, only: [ :show, :edit, :update, :destroy ]

  def index
    @receipts = current_user.receipts
                            .then { |scope| filter_by_merchant(scope) }
                            .then { |scope| filter_by_date_range(scope) }
                            .then { |scope| filter_by_amount_range(scope) }
                            .recent
  end

  def show
  end

  def claim_report
    begin
      require "prawn"
    rescue LoadError
      redirect_to receipts_path, alert: "PDF export dependency is missing. Run bundle install and try again."
      return
    end

    receipts = current_user.receipts.where(id: params[:receipt_ids])
                                  .order(purchase_date: :desc, created_at: :desc)

    if receipts.empty?
      redirect_to receipts_path, alert: "Select at least one receipt to generate a report."
      return
    end

    pdf_data = build_claim_report_pdf(receipts)

    send_data pdf_data,
              filename: "lost-luggage-claim-#{Date.current}.pdf",
              type: "application/pdf",
              disposition: "attachment"
  end

  def new
    @receipt = current_user.receipts.new(purchase_date: Date.current)
  end

  def create
    @receipt = current_user.receipts.new(receipt_params)

    if @receipt.save
      redirect_to @receipt, notice: "Receipt saved."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @receipt.update(receipt_params)
      redirect_to @receipt, notice: "Receipt updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @receipt.destroy
    redirect_to receipts_path, notice: "Receipt deleted."
  end

  private

  def set_receipt
    @receipt = current_user.receipts.find(params[:id])
  end

  def filter_by_merchant(scope)
    return scope if params[:merchant].blank?

    scope.where("merchant LIKE ?", "%#{params[:merchant].strip}%")
  end

  def filter_by_date_range(scope)
    scope = scope.where("purchase_date >= ?", params[:start_date]) if params[:start_date].present?
    scope = scope.where("purchase_date <= ?", params[:end_date]) if params[:end_date].present?
    scope
  end

  def filter_by_amount_range(scope)
    scope = scope.where("amount >= ?", params[:min_amount]) if params[:min_amount].present?
    scope = scope.where("amount <= ?", params[:max_amount]) if params[:max_amount].present?
    scope
  end

  def receipt_params
    params.require(:receipt).permit(:merchant, :amount, :purchase_date, :category, :notes, :image)
  end

  def build_claim_report_pdf(receipts)
    Prawn::Document.new(page_size: "A4", margin: 40) do |pdf|
      pdf.font_size 20
      pdf.text "Lost Luggage Claim Report", style: :bold
      pdf.move_down 6
      pdf.font_size 10
      pdf.text "Generated: #{Date.current.strftime('%b %d, %Y')}", color: "4B5563"
      pdf.text "Total claim amount: $#{format('%.2f', receipts.sum(:amount))}", style: :bold
      pdf.move_down 14

      tempfiles = []

      receipts.each_with_index do |receipt, index|
        pdf.font_size 12
        pdf.text "#{index + 1}. #{receipt.merchant}", style: :bold
        pdf.font_size 10
        pdf.text "Category: #{receipt.category}"
        pdf.text "Date: #{receipt.purchase_date.strftime('%b %d, %Y')}"
        pdf.text "Amount: $#{format('%.2f', receipt.amount)}"
        pdf.text "Notes: #{receipt.notes.presence || 'None'}"
        pdf.move_down 6

        if receipt.image.attached?
          tempfile = Tempfile.new([ "claim-receipt-#{receipt.id}", image_extension(receipt) ], binmode: true)
          tempfile.write(receipt.image.download)
          tempfile.rewind
          tempfiles << tempfile

          begin
            pdf.image tempfile.path, fit: [ 500, 260 ], position: :center
          rescue StandardError
            pdf.text "Attached image could not be rendered in PDF.", style: :italic, color: "B91C1C"
          end
        else
          pdf.text "No receipt image attached.", style: :italic, color: "6B7280"
        end

        pdf.move_down 16
        pdf.stroke_horizontal_rule
        pdf.move_down 16
      end

      tempfiles.each(&:close!)
    end.render
  end

  def image_extension(receipt)
    ext = File.extname(receipt.image.filename.to_s)
    ext.present? ? ext : ".jpg"
  end
end
