Class Demo.Operations.RAG.RAGOperation Extends Ens.BusinessOperation
{

Parameter SETTINGS = "NumberOfRetrivals:RAG";

Property NumberOfRetrivals As %String [ InitialExpression = "5" ];

Parameter INVOCATION = "Queue";

Property Model As %SYS.Python;

Method OnRAG(pRequest As Demo.GenerateRequest, pResponse As Demo.Operations.RAG.RAGResponse) As %Status
{
    Set tSc = $$$OK

    Try {
        Set tBuiltins = ##class(%SYS.Python).Builtins()
        Set tAsk = pRequest.Prompt
        Set tPrompt = ##class(Demo.Utils).GetCleanTxt(tAsk)
        Set EmbRequest = ##class(Demo.Operations.Embedding.Request).%New()
        Set EmbRequest.Chunks = "['"_tPrompt_"']"
        ///$$$TRACE(EmbRequest.Chunks)
        Set EmbResponse = ##class(Demo.Operations.Embedding.Response).%New()
        Set sc = ..SendRequestSync("Embedding Operation", EmbRequest, .EmbResponse)
        Set tEmbdding= ..EmbeddingPy(EmbResponse.Vectors)
        Set tcolumn = "Embedding"
        Set tSql = "SELECT TOP "_..NumberOfRetrivals_" ID FROM Demo.RecordEmbeddings ORDER BY VECTOR_DOT_PRODUCT("_tcolumn_" , TO_VECTOR('"_tEmbdding_"', FLOAT)) DESC"
        $$$TRACE(tSql)
        Set rList = ..Query(tSql)
        Set pResponse = ##class(Demo.Operations.RAG.RAGResponse).%New()
        Set pResponse.DocIds = rList
        Set pResponse.DocCount = ..NumberOfRetrivals
    } Catch ex {
        Set tSc = ex.AsStatus()
    }
    Return tSc
}

Method Query(sqlQuery) As %List [ Language = python ]
{
    import iris
    statement = iris.sql.exec(sqlQuery)
    df  = statement.dataframe()
    list = df.stack().tolist()
    formatted_data = ','+','.join(str(item) for item in list)
    return formatted_data
}

Method EmbeddingPy(Embeddings As %Stream.GlobalCharacter) As %String [ Language = python ]
{
    import iris

    def stream_to_string(stream)-> str:
        string = ""
        stream.Rewind()
        while not stream.AtEnd:
            string += stream.Read(1024)
        return string

    embeddings_str = stream_to_string(Embeddings)
    # self.Trace(embeddings_str)
    return embeddings_str[1:-1]
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
  <MapItem MessageType="Demo.GenerateRequest">
    <Method>OnRAG</Method>
  </MapItem>
</MapItems>
}

}
