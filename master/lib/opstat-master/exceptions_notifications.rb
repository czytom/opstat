require 'exception_notifier'
exceptions_notifiers_config = Opstat::Config.instance.get_exceptions_notifiers_config
email_options = {
        email_prefix: '[Exception] ',
        sender_address: %{"notifier" <exception-notifier@ifirma.pl>},
        exception_recipients: %w{ktomczyk@ifirma.pl}
}

exceptions_notifiers_config.each do |notifier|
  notifier_name = notifier['notifier']
  notifier_options = notifier['options']

  Opstat::Logging.oplogger.info "Registering [#{notifier_name}] exceptions notifier engine" 
  ExceptionNotifier.create_and_register_notifier(notifier_name, notifier_options)
end

