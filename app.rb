require 'sinatra'
require 'sinatra/reloader'
require 'barby'
require 'barby/barcode/code_128'
require 'barby/outputter/svg_outputter'
require 'barby/outputter/cairo_outputter'
require 'pdfkit'
require 'nokogiri'


get "/" do
    code = params[:code]
    content_type "image/svg+xml"
    if code
        barcode = Barby::Code128B.new(code)
        outputter = Barby::CairoOutputter.new(barcode)
        svg = outputter.to_svg
        doc = Nokogiri.XML svg
        doc.at("svg")["preserveAspectRatio"] = "none"
        return doc.to_xml
    else
        "code not found in the parameters"
    end
end


get "/pdf" do

    @host = request.env["HTTP_HOST"]

    @codes = params[:codes].split(":")
    @page_padding = params[:page_padding] || "8.8mm 8.4mm"

    @cell_width   = params[:cell_width]   || "48.3mm"
    @cell_height  = params[:cell_height]  || "25.4mm"
    @cell_padding = params[:cell_padding] || "0mm"
    @cell_margin  = params[:cell_margin]  || "0mm"

    @barcodes_per_page = params[:barcodes_per_page] || 11
    @barcodes_per_page = @barcodes_per_page.to_i

    html = erb :pdf

    content_type "application/pdf"
    kit = PDFKit.new(html, :margin_top => '0mm', :margin_right => '0mm', :margin_bottom => '0mm', :margin_left => '0mm')
    kit.to_pdf
end
