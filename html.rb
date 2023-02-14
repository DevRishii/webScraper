# output stuff and processing SEI into HTML format
class HTML

    def initialize(fileName)
    
        @fileName = "#{fileName}.html"
    end

    # start html page
    def startPage

    end

    # end html page
    def endPage

    end

    # start header for html page
    def startHeader

    end

    # end header for html page
    def endHeader

    end

    # add info to header, add parameters for: date, prof name, class name, course number, department, campus
    def addHeaderInfo

    end

    # add info to table
    def addTableInfo

    end

    # start a formatted table from SEI
    def startTable

    end

    # end a formatted table from SEI
    def endTable

    end

    # output html file (creates html file)
    def output(fileContents)

        File.open(@fileName, "w") {|f| f.write(fileContents)}     
    end

end