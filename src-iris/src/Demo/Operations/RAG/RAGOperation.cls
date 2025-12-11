Class Demo.Operations.RAG.RAGOperation Extends Ens.BusinessOperation
{

Parameter SETTINGS = "NumberOfRetrivals:RAG";

Property NumberOfRetrivals As %String [ InitialExpression = "3" ];

Parameter INVOCATION = "Queue";

Property Model As %SYS.Python;

Method OnRAG(pRequest As Demo.GenerateRequest, pResponse As Demo.Operations.RAG.RAGResponse) As %Status
{
    Set tSc = $$$OK

    Try {
      Set tBuiltins = ##class(%SYS.Python).Builtins()
      Set tAsk = pRequest.Prompt
      Set tPrompt = ##class(Demo.Utils).GetCleanTxt(tAsk)
      Set tStatement = ##class(%SQL.Statement).%New()
      Set tEmbdding= ..EmbeddingPy(tPrompt)
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

Method EmbeddingPy(input As %String) [ Language = python ]
{
    # Generate embeddings
    embeddings = self.Model.encode([input])[0]
    return str(embeddings.tolist())
}

Method OnInit() As %Status
{
    #dim sc As %Status = $$$OK
    try {
        do ..PyInit()
    } catch ex {
        set sc = ex.AsStatus()
    }
    quit sc
}

Method PyInit() [ Language = python ]
{
    from sentence_transformers import SentenceTransformer
    import torch
    device = 'cuda' if torch.cuda.is_available() else 'cpu'

    self.Model = SentenceTransformer("intfloat/multilingual-e5-large-instruct", cache_folder ="/usr/irissys/iriscache/hfcache", trust_remote_code=True, device=device)
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
