VestalVersions.configure do |config|
  # Place any global options here. For example, in order to specify your own version model to use
  # throughout the application, simply specify:
  #
  # config.class_name = "MyCustomVersion"
  #
  # Any options passed to the "versioned" method in the model itself will override this global
  # configuration.
end


# Fix to allow mass-assign

VestalVersions::Version.module_eval do     
  attr_accessible :modifications, :number, :user
end 