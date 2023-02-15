# output stuff and processing SEI into HTML format
class HTML

    def initialize(fileName)
    
        # This will add .html extension to the end of the file name
        # if the user did not add it or made a typo.
        if fileName.end_with?(".html")
            @fileName = fileName
        else
            @fileName = "#{fileName}.html"
        end
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

    # add a row of info to table
    def addTableInfo(fileContents, instructor, course, term, numberOfSEIs, averageRating)

        fileContents += "<tr><td>#{instructor}</td><td>#{course}</td><td>#{term}</td><td>#{numberOfSEIs}</td><td>#{averageRating}</td></tr>"
    end

    # start a formatted table from SEI
    def startTable(fileContents)

        fileContents += "<table> <style>
        table {
          border-collapse: collapse;
          width: 100%;
        }
        
        th, td {
          padding: 8px;
          text-align: left;
          border-bottom: 1px solid #ddd;
        }
        
        tr:hover {background-color: #D6EEEE;}
        </style>"

        # <style type=\"text/css\">table, th, td { border: 1px solid black; border-collapse: collapse; padding: 5px; }</style>
        # ^ If you want to use it, here is a table style I created for my own testing.
        # -Hunter

    end

    # end a formatted table from SEI
    def endTable
        fileContents += "</table>"
    end

    # output html file (creates html file)
    def output(fileContents)

        File.open(@fileName, "w") {|f| f.write(fileContents)}     
    end

end