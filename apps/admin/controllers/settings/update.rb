 module Admin::Controllers::Settings
  class Update
    include Admin::Action

    expose :settings, :active_item

    def call(params)
      redirect_if_not_admin('Attempt to change system message (admin, settings, update messge)')
      @active_item = 'admin'
      @settings = AppSettings::SettingsRepository.first
    end
  end
end
