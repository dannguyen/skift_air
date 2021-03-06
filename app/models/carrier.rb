class Carrier < ActiveRecord::Base
  include ImportConcerns::BtsCarriers
  extend FriendlyId
  include RouteAggregator

  friendly_id :name, :use => [:slugged, :finders]


  validates :code, :uniqueness => true, :presence => true

  has_many :monthly_carrier_routes, primary_key: 'code', foreign_key: 'unique_carrier_code'

# todo, refactor
  scope :with_total_passengers, ->{ joins(:monthly_carrier_routes).
                        select('carriers.*, sum(monthly_carrier_routes.passengers) AS total_passengers').
                        group('carriers.id')  }

  scope :busiest, ->{ with_total_passengers.order('total_passengers DESC') }


  # TODO: Dry up with both Airport and Carrier methods
  alias_method :routes, :monthly_carrier_routes
  delegate :destinations, :to => :routes

  def destinations(from_airport=nil)
    Airport.joins(:arriving_monthly_carrier_routes => :carrier).
    where({:carriers => {id: self.id}}).select('airports.*').
    agg_capacity.
    group("monthly_carrier_routes.origin_airport_dot_id").
    order('total_passengers DESC')
  end

  def hubs # TK: refactor
    Airport.joins(:departing_monthly_carrier_routes => :carrier).
    where({:carriers => {id: self.id}}).select('airports.*').
    agg_capacity.
    group("monthly_carrier_routes.origin_airport_dot_id").
    order('total_passengers DESC')
  end


  def hub_with_destination_agg(hub, destination)
    route_sums.
      where('monthly_carrier_routes.origin_airport_dot_id' => hub.dot_id).
      where('monthly_carrier_routes.dest_airport_dot_id' => destination.dot_id).
      group('unique_carrier_code').first
  end




  # ugh, refactor this
  def self.find_by_uid(obj)
    uid = self.get_uid(obj)
    return uid.is_a?(Carrier) ? uid : Carrier.where(code: uid).first
  end




  def self.with_route_sums # TK should refactor with RouteAggregator.route_sums
    self.joins(:monthly_carrier_routes).
      select('carriers.*').
      agg_capacity.
      group("monthly_carrier_routes.unique_carrier_code").
      order('total_passengers DESC')
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
