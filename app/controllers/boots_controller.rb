class BootsController < ApplicationController
  def dummy
    @h = Hash.new
    @h[:createPJ] = "<a href='/projects/new/'>Create a project</a>"
    @h[:indexPJ] = "<a href='/projects/'>List of projects </a>"
    @h[:filterSP] = "<a href='/projects/filterSP'>List of projects using SP</a>"
    @h[:test] = "<a href='/aaaaaaassssddds'>Route list (Will raise error, intended, do not delete)</a>" if Rails.env.development?
    # @h[:wipeall] = "<a href='/begone/'><blink>(/!&#92; NO CONFIRMATION)</blink> Factory Reset</a>" if Rails.env.development?
    @h[:admin] = "<a href='/admin'>Admin only!!! - Irreversible changes</a>"

    # render inline: "<a href='/projects/new/'>Create a project</a><br/><a href='/projects/'>List of projects </a><br/><a href='/projects/filterSP'>List of projects using SP</a><br/><a href='/begone/'>Gone!</a>"
  end
=begin
  def begone
    ModuleAssignment.destroy_all
    Project.destroy_all
    render inline: "All projects destroyed, clean state found<br/><a href='/'>Back to Index</a>Also all links are destroyed."
  end
=end
end