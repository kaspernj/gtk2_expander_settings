#A class that helps saving and restoring settings for expanders using a database.
class Gtk2_expander_settings
  ALLOWED_ARGS = [:db, :expander, :name]
  DB_SCHEMA = {
    "tables" => {
      "Gtk2_expander_settings" => {
        "columns" => [
          {"name" => "id", "type" => "int", "autoincr" => true, "primarykey" => true},
          {"name" => "name", "type" => "varchar"},
          {"name" => "expanded", "type" => "enum", "maxlength" => "'0','1'"},
          {"name" => "saved", "type" => "enum", "maxlength" => "'0','1'"}
        ],
        "indexes" => ["name"]
      }
    }
  }
  
  def initialize(args)
    #Load arguments and database.
    args.each do |key, val|
      raise "Invalid argument: '#{key}'." if !ALLOWED_ARGS.include?(key)
    end
    
    @db, @expander, @name = args[:db], args[:expander], args[:name]
    
    Knj::Db::Revision.new.init_db("db" => @db, "schema" => DB_SCHEMA)
    
    #Load or initialize saved data in database.
    if @data = @db.single(:Gtk2_expander_settings, :name => @name)
      @id = @data[:id]
    else
      @id = @db.insert(:Gtk2_expander_settings, {:name => @name, :saved => 0}, :return_id => true)
      @data = @db.single(:Gtk2_expander_settings, :id => @id)
    end
    
    #Restore saved value. Use timeouts to give window time to initialize first (to load code that may effect the expander like in OpenAll-Time-Applet).
    if @data[:saved].to_i == 1
      if @data[:expanded].to_i == 1 and !@expander.expanded?
        Gtk.timeout_add(25) do
          @expander.activate
          false
        end
      elsif @data[:expanded].to_i == 0 and @expander.expanded?
        Gtk.timeout_add(25) do
          @expander.activate
          false
        end
      end
    end
    
    #Connect signals in order to save new values.
    @expander.signal_connect_after("activate", &self.method(:on_expander_activated))
  end
  
  #Called after the expander is activated.
  def on_expander_activated(*args)
    if @expander.expanded?
      exp_val = 1
    else
      exp_val = 0
    end
    
    @db.update(:Gtk2_expander_settings, {:expanded => exp_val, :saved => 1}, {:id => @id})
  end
end