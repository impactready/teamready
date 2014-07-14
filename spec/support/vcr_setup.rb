require 'vcr'

VCR.configure do |c|
  c.default_cassette_options = { record: :once, erb: true, re_record_interval: 20.days }

  # not important for this example, but must be set to something
  c.hook_into :webmock
  c.cassette_library_dir = 'spec/vcr'
  c.ignore_localhost = true
end