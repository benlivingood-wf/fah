# Folding at Home Cookbook
Provides a definition to run a Folding@Home service.

# Requirements
A linux based architecture which supports Upstart.

# Definition Attributes
The parameters associated with this definition are the common parameters associated with a Folding@Home client:

* username - The Folding@Home username you want to contribute as.
* team - The Folding@Home team number you want to contribute to.
* passkey - The passkey which uniquely identifies the username.

# Usage
There is a default recipe which runs Folding@Home as the default user "Anonymous" on Team 0.  You most likely don't want to do this so in order to run under your name you'll have to create a recipe in /recipes using the definition provided similar to the following:

    fah "Fold as Steven" do
      username "stphung"
      team "212126"
      passkey "myreallylongpasskeythatiprobablyshouldkeeptomyself"
    end

After you create this recipe you want to include it in the run_list of any Chef nodes you want to run Folding@Home.  The name of the recipe is based on the name of the Ruby file you create it in.  If I defined the above recipe in steven.rb then I would include recipe[fah::steven] in the run_list of nodes I want to run this service on.
