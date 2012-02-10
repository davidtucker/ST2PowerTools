The Sencha Touch 2 Tools project consists of a collection of tools designed to make you more productive with your Sencha Touch 2 projects.  Currently, this consists of two separate tools: the Sencha Touch 2 Project Generator and a collection of Sencha Touch 2 live templates for the JetBrains family of IDE's.

## Sencha Touch 2 Project Generator

The Sencha Touch 2 Project Generator aims to make creating the skeleton project for your next Sencha Touch 2 project a breeze. 

>The generator is currently **Mac only** (although it may work on Windows using Cygwin - I haven't tested that yet).

The generator is an interactive Bash script that walks the user through the project creation process.  

### Configuration

To get the generator working, you will need to do two things: copy the script and templates onto your machine and update the script to let it know where you templates are.

First, you'll need to put the script somewhere on your machine that is easily accessible from the command line.  If you place it within one of the directories currently in your PATH, then you won't have to type in its directory each time.  For this example, we'll place it in `/usr/local/bin`.  This will require that you are an administrator.

Next, you'll need to take care of the templates.  When you grabbed the source from Github the generator directory contained the script (`generateSenchaTouch2Project.sh`) and a `templates` directory.  You can place the templates directory wherever you would like, but for the sake of this example, we'll put it in my Documents directory (`/Users/David/Documents`).  Once I copy this over to the `Documents` directory, I'll need to edit the script to tell it where to find the templates.  If you open the `generateSenchaTouch2Project.sh` file, you will notice a single configuration variable around line 41:

    SENCHA_TEMPLATE_DIRECTORY="/Projects/LiveTemplates/templates"

You will need to change this to point to the directory where you just placed your templates.  In my case:

    SENCHA_TEMPLATE_DIRECTORY="/Users/David/Documents/templates"

Congrats, you are now ready to use the generator.

### Usage

Using the generator script is simple.  First, open a terminal and navigate to the directory where you want to generate a new project.  Next, run the script from that location.  If you saved it in the recommended location, you can just type this:

    generateSenchaTouch2Project.sh

If you see the message `The template directory is not valid - it does not contain an index.html and app.js file` then you did not properly configure the template directory.  

The script itself will guide you through the creation process by asking for three pieces of information:

1.  Application Name - This is used as the title of your HTML page, and the variable can be configured to be used anywhere within your templates.
2.  Application Namespace - This is the value that will become your application namespace and it will be used within each of your JavaScript files.
3.  Sencha Touch 2 SDK Relative Path - This is the relative path from the current directory to the Sencha Touch SDK 2 Directory.

After entering these three pieces of information, your project will be generated into the current directory based on the templates from the templates directory.

### Advanced Usage

While the generator ships with a default template, you can alter these templates to include anything that you would like to have.  If you examine the templates, you will notice that variables are defined between percent signs.  There are currently four variables available to you that you can use within your custom templates:

1. `%SENCHA_TOUCH_RELATIVE_DIRECTORY%` - This is the relative path to the Sencha Touch 2 SDK
2. `%SENCHA_TOUCH_RELATIVE_DIRECTORY_SPLIT%` - This is the relative path split into its parts (mainly for config.rb)
3. `%APPLICATION_NAME%` - The name of the application
4. `%NAMESPACE_NAME%` - The namespace defined for the application

The generator will copy over all files in your templates directory as scan each of them for any of these variables.

## Sencha Touch 2 Live Templates / Snippets

__Coming Soon__

## Reporting Issues & Improvements

If you discover any bugs or wish to request a feature, please [Submit a New Issue](https://github.com/davidtucker/senchaTouch2Tools/issues/new) on Github.




