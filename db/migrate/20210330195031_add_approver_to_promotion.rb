class AddApproverToPromotion < ActiveRecord::Migration[6.1]
  def change
    add_reference :promotions, :approver, foreign_key: { to_table: :users }
    add_column :promotions, :approved_at, :datetime
  end
end
