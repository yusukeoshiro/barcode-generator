require 'sinatra'
require 'barby'
require 'barby/barcode/code_128'
require 'barby/outputter/svg_outputter'
require 'barby/outputter/cairo_outputter'

get "/" do
    code = params[:code]
    if code
        barcode = Barby::Code128B.new('BARBY')
        outputter = Barby::CairoOutputter.new(barcode)
        outputter.to_svg
    else
        "code not found in the parameters"
    end
end
