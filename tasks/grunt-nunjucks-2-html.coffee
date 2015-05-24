###
Nunjucks to HTML
https://github.com/vitkarpov/grunt-nunjucks-2-html
Render nunjucks templates
###
module.exports = (grunt) ->
  @config 'nunjucks',
    build:
      options:
        paths: '<%= path.source.layouts %>/'
        data: '<%= data %>'

        configureEnvironment: (env) ->

          markdown = require('nunjucks-markdown')
          marked = require('marked')

          markdown.register(env, marked)

          getDeep = (obj, path, isMenu) ->

            if typeof obj != 'object' or Array.isArray(obj)
              grunt.log.error(['`' + obj + '` is not an object'])
            if !Array.isArray(path)
              grunt.log.error(['`' + path + '` is not an array'])

            i = 0
            while i < path.length

              key = path[i]

              if isMenu and i > 0
                obj = obj.sub
              if !hasOwnProperty.call(obj, key)
                grunt.log.error(['Provided object doesn\'t contain requested key `' + key + '`'])
                return undefined
              obj = obj[key]

              i++

            obj

          contains = (array, value, only) ->

            only = only || false

            if !Array.isArray(array)
              grunt.log.error(['`' + array + '` is not an array'])

            if Array.isArray(value)
              i = 0
              while i < value.length
                if (array.indexOf(value[i]) == -1)
                  return false
                i++
              if only
                i = 0
                while i < array.length
                  if (value.indexOf(array[i]) == -1)
                    return false
                  i++
              return true
            else
              if (array.indexOf(value) > -1)
                return true
              else
                return false

          env.addGlobal 'getDeep', (obj, path) ->
            getDeep(obj, path, false)

          env.addGlobal 'getPage', (obj, path) ->
            getDeep(obj, path, true)

          env.addFilter 'popIn', (array, value) ->
            array.pop()
            array.push(value)
            array

          env.addFilter 'pushIn', (array, value) ->
            array.push(value)
            array

          env.addFilter 'formatDate', (date) ->
            date.replace('T', ' ').substr(0, 16)

          env.addFilter 'contains', (array, value, only) ->
            contains(array, value, only)

          getMinMaxValue = (type, input, property, path) ->

            path = path || false

            if type == 'min'
              result = Infinity
            else if type == 'max'
              result = -Infinity

            if Array.isArray(input)

              i = 0
              while i < input.length
                if path
                  object = getDeep(input[i], path, false)
                  value = object[property]
                else
                  value = input[i][property]
                if typeof value == 'string'
                  value = parseFloat(value.replace(/\./g,'').replace(',', '.'))
                if typeof value != 'string' && typeof value != 'number'
                  value = result
                if type == 'min'
                  if value < result
                    result = value
                else if type == 'max'
                  if value > result
                    result = value
                i++

            else
              grunt.log.error(['minValue filter: only arrays supported'])

            if isFinite(result)
              return result
            else
              grunt.log.error(['minValue filter: returned null'])
              return null

          env.addFilter 'minValue', (input, property, path) ->
            getMinMaxValue('min', input, property, path)

          env.addFilter 'maxValue', (input, property, path) ->
            getMinMaxValue('max', input, property, path)

          # @todo Add floats support
          env.addFilter 'formatNumber', (value, delimeter, position) ->
            delimeter = delimeter || " "
            position = position || 3

            if typeof position != 'number'
              grunt.log.error(['`' + position + '` is not a number'])
            if value % 1 != 0
              grunt.log.error(['`' + value + '` is a float. Floats not supported yet and will yield wrong results'])

            if value.length <= position
              return value
            else
              value = value.toString().split('').reverse()
              atChar = 0
              i = 0
              while i < value.length
                if atChar == position
                  value.splice i, 0, delimeter
                  atChar = -1
                atChar++
                i++
            value.reverse().join('')

        preprocessData: (data) ->

          path = require('path')

          layoutsDir = grunt.template.process('<%= path.source.layouts %>/')

          filepath = path.dirname(@src[0]).replace(layoutsDir, '').split('/')
          basename = path.basename(@src[0], '.nj')

          data.page = data.page || {}

          data.page.breadcrumb = filepath
          data.page.basename = basename
          data.page.dirname = filepath.slice(-1)[0]

          data

      files: [
        expand: true
        cwd: '<%= path.source.layouts %>/'
        src: ['{,**/}*.nj', '{,**/}*.html', '!{,**/}_*.nj']
        dest: '<%= path.build.root %>/'
        ext: '.html'
      ]