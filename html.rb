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
    def startPage(fileContents)
        
    end

    # end html page
    def endPage(fileContents)

    end

    # start header for html page
    def startHeader(fileContents)
        fileContents += "<header>"
    end

    # end header for html page
    def endHeader(fileContents)
        fileContents += "</header>"
    end

    # add info to header, add parameters for: date, prof name, class name, course number, department, campus
    def addHeaderInfo(fileContents, date, instructor, course, dpt, campus)
        fileContents += "<h1>#{date}</h1><h2>#{instructor}</h2><h3>#{course}</h3><h4>#{dpt}</h4><h5>#{campus}</h5>"
    end

    # add a row of info to table
    def addTableInfo(fileContents, instructor, course, campus, term, numberOfSEIs, averageRating)
        fileContents += "<tr><td>#{instructor}</td><td>#{course}</td><td>#{campus}</td><td>#{term}</td><td>#{numberOfSEIs}</td><td>#{averageRating}</td></tr>"
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
        </style>
        
        <tr><td>Instructor</td><td>Course</td><td>Campus</td><td>Term</td><td># of SEI's</td><td>Average Rating</td></tr>
        "


    end

    # end a formatted table from SEI
    def endTable(fileContents)
        fileContents += "</table>"
    end

    # output html file (creates html file)
    def output(fileContents)
        File.open(@fileName, "w") {|f| f.write(fileContents)}     
    end

end