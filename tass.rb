require 'fileutils'
require 'json'
require_relative 'glob.rb'
Dir["lib/cmd/*.rb"].each {|file| require_relative file}

include Glob

begin
  Glob::wdir.each do |key, value|
    unless Dir.exist?(value) or value[-1] != '/'
      FileUtils.mkdir_p(value)
    end
    if File.zero?(Glob::wdir['config'])
      configf = Glob::wdir['config']
      dosm = { "start_msg" => true }
      Glob::FileHandler.write(configf, dosm)
    end
  end
rescue Errno::ENOENT
  raise "Errno::ENOENT - Folder does not exist"
end

welcome = Array[
  "  ___________________",
  "' ,__________,  ':  `.",
  "| '            `  |    `.",
  "| |   Welcome  |  |      `.",
  "| |     to     |  |        \\      The text-based,",
  "| |   TAssign  |  |         ]          code junky,",
  "| |            |  |~~~~~~.  )            student planner.",
  "| `,__________,'  |\\__O\\_| ,'",
  "|    _______      |     \\.`",
  "|<> [___=___](@)<>|    .'\\",
  "':________________/__.'   )",
  "   (____________)        /",
  "                        /",
  "              _________/",
  "  ___________/______",
  " /''''=========='(@)\\___",
  " |[][][][][][][][][]|   \\ _______",
  " |[][][][][][][][][]|    \\__     \\",
  " |[][][][][][][][][]|    |  \..  |",
  " \\------------------/    | ( # ) |",
  "                         |  '''  |",
  "                         \\_______/\n"
]
prompt = "$ "

if Glob::FileHandler.read(Glob::wdir['config'])['start_msg']
  startup = ["\n\nTo get started. Read the README at " + Glob.white("https://github.com/TAssign/TAssign/blob/master/README.md"),
             "Or type " + Glob.white("help") + " to explore commands.",
             "\nTip: You can stop this message from printing when starting up by entering " + Glob.white("config startup off") + "\n\n"]
  welcome.concat(startup)
end

Clear.call
sleep(0.1)
for msg in welcome
  puts "\t" + msg
  sleep(0.01)
end


while true
  print prompt
  cmd = gets.chomp
  
  unless cmd.empty?
    opts = cmd.split(' ')

    case opts[0]
    when "help"
      Help.call(opts)

    when "quit", "exit"
      puts "Goodbye."
      break

    when "clear"
      Clear.call

    when "config"
      Config.call(opts)

    when "stud"
      Stud.call(opts)

    else
      puts "Command '" + cmd + "' does not exist.\nUser 'help' for more info."
    end
  end
end

