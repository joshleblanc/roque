Rails.application.config.after_initialize do
  # Prevent bot from running in rake tasks, migrations, or console
  if !(defined?(Rails::Console) || File.split($0).last == "rake" || (File.split($0).last == "rails" && ARGV.first == "db:migrate"))
    Bot.instance.run
  end
end
