Class Demo.Operations.Embedding.Operation Extends Ens.BusinessOperation
{

Property BatchSize As %Integer [ InitialExpression = 64 ];

Property CacheFolder As %String(MAXLEN = 100) [ InitialExpression = "/usr/irissys/iriscache/hfcacheQ" ];

Property ModelName As %String [ InitialExpression = "Qwen/Qwen3-Embedding-0.6B" ];

Property Model As %SYS.Python;

Property NumVectors As %Integer;

Parameter SETTINGS = "ModelName:Embedding, BatchSize:Embedding, CacheFolder:Embedding";

Method OnGetEmbeddings(pRequest As Demo.Operations.Embedding.Request, Output pResponse As Demo.Operations.Embedding.Response) As %Status
{
    Set tSc = $$$OK
    Try{
        Set pResponse = ##class(Demo.Operations.Embedding.Response).%New()
        Set embeddings = ..EmbeddingsList(pRequest.Chunks)
        Set pResponse.Vectors = embeddings
        Set pResponse.VectorsNumber = ..NumVectors
    }
    Catch tEx {
        Set tSc = tEx.AsStatus()
    }
    
    Quit tSc
}

Method EmbeddingsList(input) As %Stream.GlobalCharacter [ Language = python ]
{
    import torch
    import numpy as np
    import ast
    import iris 

    def string_to_stream(string:str):
        stream = iris.cls('%Stream.GlobalCharacter')._New()
        n = 1024
        chunks = [string[i:i+n] for i in range(0, len(string), n)]
        for chunk in chunks:
            stream.Write(chunk)
        return stream

    arr = ast.literal_eval(input)

    with torch.no_grad():  
        embeddings = self.Model.encode(arr, 
                                  convert_to_numpy=True, 
                                  batch_size=self.BatchSize, 
                                  show_progress_bar=False, 
                                  normalize_embeddings=True)

    embeddings_str = "[" + ",".join("[" + ",".join(map(str, row)) + "]" for row in embeddings ) + "]"

    stream = string_to_stream(embeddings_str)
    self.NumVectors = embeddings.shape[0]
    return stream
}

Method PyInit() [ Language = python ]
{
    import torch
    from sentence_transformers import SentenceTransformer

    device = 'cuda' if torch.cuda.is_available() else 'cpu'
    self.Model = SentenceTransformer("intfloat/multilingual-e5-large-instruct", cache_folder ="/usr/irissys/iriscache/hfcache", trust_remote_code=True, device=device)
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
  <MapItem MessageType="Demo.Operations.Embedding.Request">
    <Method>OnGetEmbeddings</Method>
  </MapItem>
</MapItems>
}

}
