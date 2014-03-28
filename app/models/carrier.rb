class Carrier < ActiveRecord::Base
  validates :code, :uniqueness => true, :presence => true

  has_many :monthly_carrier_routes, primary_key: 'code', foreign_key: 'unique_carrier_code'


  # ugh, refactor this
  def self.find_by_uid(obj)
    uid = self.get_uid(obj)
    return uid.is_a?(Carrier) ? uid : Carrier.where(code: uid).first
  end


  # obj can either be a:
  # - Carrier object
  # - Rails numerical id
  # - FAA code, like "DL"

  # returns (for now): FAA :code, i.e. "DL"
  def self.get_uid(obj)
    return case obj
    when Carrier
      obj.code
    when Fixnum # assume numerical ID
      Carrier.find(obj).code
    else  # assume it is code, e.g. 'DL'
      obj
    end
  end

end
