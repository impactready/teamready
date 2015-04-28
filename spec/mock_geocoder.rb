module MockGeocoder
  def self.included(base)
    base.before :each do
      ::Geocoder.stub(:search).and_returns(reverse_merge!(address: '20 Corlett Drive', coordinates: [-26.1249, 28.0087], state: 'Gauteng', state_code: '2196', country: 'South Africa', country_code: '27'))
    end
  end
end