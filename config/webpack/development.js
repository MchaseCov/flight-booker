process.env.NODE_ENV = process.env.NODE_ENV || 'development'

const environment = require('./environment')

module.exports = environment.toWebpackConfig()

const webpack = require('webpack')

module.exports = {
    resolve: {
        alias: {
            $: 'jquery/src/jquery',
            jQuery: 'jquery/src/jquery',
            jquery: 'jquery',
            'jquery-ui': 'jquery-ui-dist/jquery-ui.js'
        }
    },
    plugins: [
        new webpack.ProvidePlugin({
            $: 'jquery',
            jQuery: 'jquery'
        })
    ]
}