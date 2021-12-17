require_relative '../student.rb'
class Stud

  #
  # ERRORS
  #

  class Errors
    def self.InvalidStudAll
      "Invalid options for " + Glob.white("stud -a")
    end

    def self.StudentExists(stud)
      "Student " + Glob.white(stud) + " already exists.\n"\
      + "Use " + Glob.white("stud " + stud) + " to log in."
    end
  end

  #
  # CALL METHOD
  # 

  def self.call(options=["stud"])
    options.shift

    if options[0] == "-n"
        if options[1] != nil
          if not Student.all.include? options[1]
            ns = Student.new(username=options[1])
            ns_hash = ns.hashit
            Glob::FileHandler.write(ns.file, ns_hash)
            puts "Success.\nUser '" + ns.username + "' created."
          else
            puts Errors.StudentExists(options[1])
          end
        else
          puts "No username entered.\nFollow 'stud -n <username>'\n"
        end
    elsif options.length == 0
      if Glob::TassConfig.logged_in?
        puts "Current student: " + Glob.white(Glob::TassConfig.curr_stud.username)
      else
        puts "You are not currently logged in."
      end
    elsif options[0][0...2] == "-a"
      all(options[0])
    elsif Student.all.include? options[0]
      puts "Successfully logged into " + Glob.white(options[0])
      Glob::TassConfig.set_stud(Student.get_stud(options[0]))
    else
      puts "Invalid options or user. Please see " + Glob.white("help stud") + " for more information"
      puts "or use " + Glob.white("stud -a") + " to view existing users."
    end
  end

  #
  # START DOC INFORMATION
  #

  def self.name
    "stud"
  end

  def self.desc
    "Select, create, or switch students"
  end

  def self.options
    "\tOptions:\n"\
    ""+Glob.white("\t\t-n") + " : " + Glob.white("stud -n <username>\n")+""\
    "\t\t\tCreates a new student with the username username\n"\
    ""+Glob.white("\t\t-a[v]") + " : " + Glob.white("stud -a[v]\n")+""\
    "\t\t\tPrint all existing users.\n\t\t\tUse " + Glob.white("-av") + " for verbosity."
  end

  #
  # END DOC INFORMATION
  #
  # START HELPER FUNCTIONS
  #

  private
  def self.all(opts)
    if opts.length > 3
      puts Errors.InvalidStudAll
    elsif opts.length == 3
      if opts[2] == "v"
        puts "Student.all WITH VERBOSITY"
      else
        puts Errors.InvalidStudAll
      end
    else
      studs = ""
      if Student.all.length == 0
        studs = "No user exist yet. Please use " + Glob.white("stud -n <username>") + " to create a new user."
      else
        Student.all.each do |stud|
          studs += stud + "\t"
        end
      end
      puts studs
    end
  end

  #
  # END HELPER FUNCTIONS
  #
end

