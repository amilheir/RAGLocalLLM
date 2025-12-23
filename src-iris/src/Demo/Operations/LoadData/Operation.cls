Class Demo.Operations.LoadData.Operation Extends Ens.BusinessOperation
{

Property ChunkSize As %Integer [ InitialExpression = 256 ];

Property ChunkOverlap As %Integer [ InitialExpression = 25 ];

Property BatchSize As %Integer [ InitialExpression = 64 ];

Parameter SETTINGS = "ChunkSize:Text Chunking,ChunkOverlap:Text Chunking,BatchSize:Text Chunking";

Method OnGetEmbeddings(pRequest As Demo.Operations.LoadData.Request, pResponse As Demo.Operations.LoadData.Response) As %Status
{
    Set tSc = $$$OK
    Try{
        Set tId = pRequest.Pdf
        Set tPdf = ##class(Demo.PDFRecord).%OpenId(tId)
        Set tCleanText = ##class(Demo.Utils).GetCleanTxt(tPdf.Text)
        Set EmbRequest = ##class(Demo.Operations.Embedding.Request).%New()
        Set EmbRequest.Chunks = ##class(Demo.Utils).GetChunks(tCleanText, 256, 25)
        Set EmbResponse = ##class(Demo.Operations.Embedding.Response).%New()
        Set sc = ..SendRequestSync("Embedding Operation", EmbRequest, .EmbResponse)
        Set tlast = ..InsertChunks(tId, EmbResponse.Vectors, EmbRequest.Chunks)
        ///$$$TRACE(tlast)
        Set pResponse = ##class(Demo.Operations.LoadData.Response).%New()
        Set pResponse.NumberEmbeddings = EmbResponse.VectorsNumber
    }
    Catch tEx {
        Set tSc = tEx.AsStatus()
    }
    
    Quit tSc
}

Method InsertChunks(Id As %Integer, Embeddings As %Stream.GlobalCharacter, Chunks As %String) As %String [ Language = python ]
{
    import iris
    import json
    import ast 

    def stream_to_string(stream)-> str:
        string = ""
        stream.Rewind()
        while not stream.AtEnd:
            string += stream.Read(1024)
        return string

    embeddings_str = stream_to_string(Embeddings)
    matrix_arr = json.loads(embeddings_str)
    chunks_arr =  ast.literal_eval(Chunks)

    for index, vector in enumerate(matrix_arr):
        vector_string = "["+",".join(map(str, matrix_arr[index]))+"]"
        sqlQuery= f'INSERT INTO Demo.RecordEmbeddings (DataSourceId,SourceId,Text,Embedding) VALUES ({Id},{index}, \'{chunks_arr[index]}\', TO_VECTOR(\'{vector_string}\',FLOAT))'
        statement = iris.sql.exec(sqlQuery)
    return f'Number of chunks added {index}.'
}

ClassMethod LogInfo(Msg As %String)
{
    $$$LOGINFO(Msg)
}

ClassMethod Trace(Msg As %String)
{
    $$$TRACE(Msg)
}

XData MessageMap
{
<MapItems>
  <MapItem MessageType="Demo.Operations.LoadData.Request">
    <Method>OnGetEmbeddings</Method>
  </MapItem>
</MapItems>
}

}
