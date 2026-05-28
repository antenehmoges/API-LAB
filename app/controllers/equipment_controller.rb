class EquipmentController < ApplicationController
  before_action :set_equipment, only: [:show, :update, :destroy]

 
  def index
    equipment = Equipment.includes(:category).order(:name)
    equipment = equipment.where(status: params[:status]) if params[:status].present?

    render json: equipment.map { |e| equipment_with_category(e) }
  end


  def show
    render json: equipment_full_detail(@equipment)
  end

 
  def create
    # Validate category exists first
    if params[:equipment]&.key?(:category_id)
      category_id = params[:equipment][:category_id]
      unless Category.exists?(category_id)
        return render json: { errors: ["Category must exist"] }, status: :unprocessable_entity
      end
    end

    equipment = Equipment.new(equipment_params)
    if equipment.save
      render json: equipment_with_category(equipment), status: :created
    else
      render json: { errors: equipment.errors.full_messages }, status: :unprocessable_entity
    end
  end
d
  def update
    if params[:equipment]&.key?(:category_id)
      category_id = params[:equipment][:category_id]
      unless Category.exists?(category_id)
        return render json: { errors: ["Category must exist"] }, status: :unprocessable_entity
      end
    end

    if @equipment.update(equipment_params)
      render json: equipment_with_category(@equipment)
    else
      render json: { errors: @equipment.errors.full_messages }, status: :unprocessable_entity
    end
  end


  def destroy
    @equipment.destroy
    head :no_content
  end

  private

  def set_equipment
    @equipment = Equipment.includes(:category, :maintenance_records).find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Equipment not found" }, status: :not_found
  end

  def equipment_params
    params.require(:equipment).permit(:name, :serial_number, :status, :category_id)
  end

  def equipment_with_category(equipment)
    equipment.as_json.merge(category_name: equipment.category&.name)
  end

  def equipment_full_detail(equipment)
    equipment.as_json.merge(
      category: equipment.category,
      maintenance_records: equipment.maintenance_records.order(performed_at: :desc)
    )
  end
end
