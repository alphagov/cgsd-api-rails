class ServicesController < APIController
  def show
    service = Service.where(natural_key: params[:id]).first!
    render json: service
  end
end
