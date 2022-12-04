#!/bin/sh

install_laravel_mix()
{
    echo "Installing Laravel-Mix"
    npm install laravel-mix --save-dev
    #create file webpack.mix.js
    touch webpack.mix.js
    #add code to webpack.mix.js

echo "const mix = require('laravel-mix');

mix.options({
    processCssUrls: false // Process/optimize relative stylesheet url()'s. Set to false, if you don't want them touched.
  });
/*|--------------------------------------------------------------------------
 | Mix Asset Management
 |--------------------------------------------------------------------------
 |
 | Mix provides a clean, fluent API for defining some Webpack build steps
 | for your Laravel applications. By default, we are compiling the CSS
 | file for the application as well as bundling up all the JS files.
 |*/

mix.js('resources/js/app.js', 'public/js')
    .sass('resources/sass/app.scss', 'public/css');" > webpack.mix.js
}


findAndReplacePackageJson() {
    #find and replace "dev": "vite", \n\t "build": "vite build" to ""dev": "npm run development", \n\t "build": "npm run production"} in package.json

    #change color to yellow
    echo -e "\033[33m"
    echo "Finding and replacing in package.json"
    #change color to blue
    echo -e "\033[34m"
    sed -i 's/"dev": "vite"/"dev": "npm run development"/g' package.json
    sed -i 's/"build": "vite build"/"development": "mix",\n\t\t "watch": "mix watch",\n\t\t "watch-poll": "mix watch -- --watch-options-poll=1000",\n\t\t "hot": "mix watch --hot",\n\t\t "prod": "npm run production",\n\t\t "production": "mix --production"/g' package.json
    echo "Done Replacing"
}

replaceEnv(){
    #change color to yellow
    echo -e "\033[33m"
    #find and replace VITE_ to MIX_ in .env
    echo "Finding and replacing in .env"

    #change color to blue
    echo -e "\033[34m"
    sed -i 's/VITE_/MIX_/g' .env
    echo "Done Replacing"
}

replaceViteInResources() {
    #change color to yellow
    echo -e "\033[33m"

    #find and replace VITE to MIX in resources/js/app.js
    echo "Finding and replacing in resources/js/app.js"
    sed -i 's/VITE/MIX/g' resources/js/app.js
    sed -i 's/VITE/MIX/g' resources/js/bootstrap.js


    #change color to blue
    echo -e "\033[34m"
    echo "Done Replacing"
}

refreshBladeFiles() {
    #change color to yellow
    echo -e "\033[33m"

    #find and replace @viteReactRefresh to <link rel="stylesheet" href="{{ mix('css/app.css') }}"> in all blade files in resources/views
    echo "Finding and replacing in all blade files in resources/views"
    sed -i "s/@viteReactRefresh/<link rel=\"stylesheet\" href=\"{{ mix('css/app.css') }}\">/g" resources/views/**/*.blade.php
    sed -i "s/@vite('resources/js/app.js')/<script src=\"{{ mix('js/app.js') }}\" defer></script>/g" resources/views/**/*.blade.php

    #change color to blue
    echo -e "\033[34m"
    echo "Done Replacing"
}

removeDependencies()
{
    #change color to pink
    echo -e "\033[35m"

    echo "Removing vite and its dependencies"
    npm remove vite laravel-vite-plugin
    rm vite.config.js
    #change color to green
    echo -e "\033[32m"
    echo "Done Removing vite and its dependencies"

    #remove /bootstrap/ssr and /public/build in all .gitignore files
    sed -i '/\/bootstrap\/ssr/d' .gitignore
    sed -i '/\/public\/build/d' .gitignore


}

configureLaravelMix()
{
    install_laravel_mix
    findAndReplacePackageJson
    replaceEnv
    replaceViteInResources
    refreshBladeFiles
    removeDependencies

    #change color to green
    echo -e "\033[32m"
    echo "Done configuring Laravel Mix"
}

#MIX TO VITE

update_laravel()
{
    #change color to pink
    echo -e "\033[35m"
    echo "Updating Laravel"
    composer require laravel/framework:^9.19.0
    #change color to green
    echo -e "\033[32m"
    echo "Done Updating Laravel"
}

install_vite()
{
    #change color to pink
    echo -e "\033[35m"
    echo "Installing Vite"
    npm install --save-dev vite laravel-vite-plugin
    #change color to green
    echo -e "\033[32m"
    echo "Done Installing Vite"
}

vue_for_vite()
{
    #change color to pink
    echo -e "\033[35m"
    echo "Installing Vite for Vue"
    npm install --save-dev @vitejs/plugin-vue
    #change color to green
    echo -e "\033[32m"
    echo "Done Installing Vite for Vue"
}
react_for_vite()
{
    #change color to pink
    echo -e "\033[35m"
    echo "Installing React Plugin for Vite"
    npm install --save-dev @vitejs/plugin-react
    #change color to green
    echo -e "\033[32m"
    echo "Done Installing React Plugin for Vite"
}

configure_vite_file()
{
    #change color to pink
    echo -e "\033[35m"
    echo "Configuring Vite"

    touch vite.config.js
echo "import { defineConfig } from 'vite';
import laravel from 'laravel-vite-plugin';

export default defineConfig({
    plugins: [
        laravel({
            input: [
                'resources/sass/app.scss',
                'resources/vendor/bootstrap/scss/bootstrap.scss',
                'resources/js/app.js',
            ],
            refresh: true,
        }),
        // react(),
        // vue({
        //     template: {
        //         transformAssetUrls: {
        //             base: null,
        //             includeAbsolute: false,
        //         },
        //     },
        // }),
    ],
});
" > vite.config.js

    #change color to green
    echo -e "\033[32m"
    echo "Done configuring Vite"

}

searchAndReplaceConfig()
{
    #change color to pink
    echo -e "\033[35m"
    echo "Searching and replacing in Package.json"

    sed -i 's/"dev": "npm run development",/"dev": "vite",/g' package.json
    sed -i 's/"development": "mix",/"build": "vite build"/g' package.json
    sed -i 's/"watch": "mix watch",/ /g' package.json
    sed -i 's/"watch-poll": "mix watch -- --watch-options-poll=1000",/ /g' package.json
    sed -i 's/"hot": "mix watch --hot",//g' package.json
    sed -i 's/"prod": "npm run production",//g' package.json
    sed -i 's/"production": "mix --production"//g' package.json

    #change color to green
    echo -e "\033[32m"
    echo "Done Searching and replacing in Package.json"
}

update_env_vite()
{
    #change color to pink
    echo -e "\033[35m"
    echo "Updating .env"
    echo "Finding and replacing in .env"

    #change color to blue
    echo -e "\033[34m"
    sed -i 's/MIX_/VITE_/g' .env
    echo "Done Replacing"

}

update_resource()
{
    #change color to pink
    echo -e "\033[35m"

    #find and replace VITE to MIX in resources/js/app.js
    echo "Finding and replacing in resources/js/app.js"
    sed -i 's/MIX/VITE/g' resources/js/app.js
    sed -i 's/MIX/VITE/g' resources/js/bootstrap.js


    #change color to blue
    echo -e "\033[34m"
    echo "Done Replacing"
}

update_app_js()
{
    #channge color to pink
    echo -e "\033[35m"

    echo "Finding and replacing in all blade files in resources/views"
    sed -i "s/<link rel=\"stylesheet\" href=\"{{ mix('css\/app.css') }}\">/@vite(['resources/css/app.css', 'resources/js/app.js'])/g" resources/views/**/*.blade.php
    sed -i "s/<script src=\"{{ mix('js\/app.js') }}\" defer></script>//g" resources/views/**/*.blade.php

    #change color to blue
    echo -e "\033[34m"
    echo "Done Replacing"
}

remove_laravel()
{
    #change color to pink
    echo -e "\033[35m"
    echo "Removing Laravel Mix"
    npm remove laravel-mix
    rm webpack.mix.js
    #change color to green
    echo -e "\033[32m"
    echo "Done Removing Laravel Mix"
}

add_line_to_gitignore()
{
    #change color to pink
    echo -e "\033[35m"
    echo "Adding /bootstrap/ssr and /public/build to .gitignore"
    echo "/bootstrap/ssr" >> .gitignore
    echo "/public/build" >> .gitignore
    #change color to green
    echo -e "\033[32m"
    echo "Done Adding /bootstrap/ssr and /public/build to .gitignore"
}

configureVite()
{
    read -p "Do you want to update Laravel? (y/n) " update_laravel
    if [ "$update_laravel" == "y" ]
    then
        update_laravel
    fi

    install_vite
    read -p "What Plugin do you use? [vue/react] " vite
    if [ "$vite" = "vue" ]
    then
        vue_for_vite
    elif [ "$vite" = "react" ]
    then
        react_for_vite
    else
        vue_for_vite
    fi
    configure_vite_file
    searchAndReplaceConfig
    update_env_vite
    update_resource
    update_app_js
    remove_laravel
    add_line_to_gitignore

    #change color to green
    echo -e "\033[32m"
    echo "Done configuring Vite"
}

start()
{
    #change color to blue
    echo -e "\033[34m"
    echo "SANNYTECH - Make it easy switching from Vite to Laravel-Mix and vice versa"

    #change color to green
    echo -e "\033[32m"
    echo "1. Configure Laravel Mix"
    echo "2. Configure Vite"
    echo "3. Exit"


    #change color to blue
    echo -e "\033[34m"
}



choice=4
while [ "$choice" -ne 3 ]
do
    start
    read -p "Enter your choice [ 1 - 3 ] " choice
    case "$choice" in
        1) read -p "Do you wish to proceed? [y/n] " yn
            if [ "$yn" = "y" ]
            then
                configureLaravelMix
            else
                #change color to red
                echo -e "\033[31m"
                echo "Aborting"
                choice=4
            fi
        ;;
        2) read -p "Do you wish to proceed? [y/n] " yn
            if [ "$yn" = "y" ]
            then
                configureVite
            else
                #change color to red
                echo -e "\033[31m"
                echo "Aborting"
                choice=4
            fi
        ;;
        3) clear
            echo "Bye"
        ;;
        *) echo -e "${RED}Error...${STD}" && sleep 2
    esac
done

#change color to white
echo -e "\033[37m"
echo "For more information, visit https://github.com/BhoiDanny"
echo "Thank you for using my Script - Make it easy switching from Vite to Laravel-Mix and vice versa"

#change color to green
echo -e "\033[32m"
echo "Done"
exit 0
#change color to white
echo -e "\033[37m"



