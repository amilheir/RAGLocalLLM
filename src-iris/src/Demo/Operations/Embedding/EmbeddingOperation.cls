Class Demo.Operations.Embedding.EmbeddingOperation Extends Ens.BusinessOperation
{

Property ChunkSize As %Integer [ InitialExpression = 256 ];

Property ChunkOverlap As %Integer [ InitialExpression = 25 ];

Property BatchSize As %Integer [ InitialExpression = 64 ];

Parameter SETTINGS = "ChunkSize:Text Chunking,ChunkOverlap:Text Chunking,BatchSize:Text Chunking";

Property Model As %SYS.Python;

Method OnGetEmbeddings(pRequest As Demo.Operations.Embedding.EmbeddingRequest, pResponse As Demo.Operations.Embedding.EmbeddingResponse) As %Status
{
    Set tSc = $$$OK
    Try{
        Set tId = pRequest.Pdf
        Set tPdf = ##class(Demo.PDFRecord).%OpenId(tId)
        Set tCleanText = ##class(Demo.Utils).GetCleanTxt(tPdf.Text) 
        Set tChunks = ##class(Demo.Utils).GetChunks(tCleanText, ..ChunkSize, ..ChunkOverlap)
        Set tEmbddings = ..EmbeddingsList(tChunks)
        /// OR &sql(INSERT INTO Demo.RecordEmbeddings (DataSourceId,SourceId,Text,CleanText) VALUES (:tId,:tRecordId,:tChunk,:tCleanChunk))
        Set tlast = ..InsertChunks(tId, tEmbddings, tChunks)
        $$$TRACE(tlast)
        Set pResponse = ##class(Demo.Operations.Embedding.EmbeddingResponse).%New()
        Set pResponse.NumberEmbeddings = tChunks."__len__"()
    }
    Catch tEx {
        Set tSc = tEx.AsStatus()
    }
    
    Quit tSc
}

Method EmbeddingsList(input As %SYS.Python) As %SYS.Python [ Language = python ]
{
    from sentence_transformers import SentenceTransformer
    import torch

    device = 'cuda' if torch.cuda.is_available() else 'cpu'
    model = SentenceTransformer("intfloat/multilingual-e5-large-instruct", cache_folder ="/usr/irissys/iriscache/hfcache", trust_remote_code=True, device=device)
    # Generate embeddings
    embeddings = model.encode(input, batch_size=self.BatchSize)
    return embeddings
}

Method InsertChunks(Id As %Integer, Embeddings As %SYS.Python, Chunks As %SYS.Python) As %String [ Language = python ]
{
    import iris

    values = []
    for index, vector in enumerate(Embeddings):
        vector_string = "["+",".join(map(str, Embeddings[index]))+"]"
        values.append(f'{Id},{index}, \'{Chunks[index]}\', TO_VECTOR(\'{vector_string}\',FLOAT)')
        sqlQuery= f'INSERT INTO Demo.RecordEmbeddings (DataSourceId,SourceId,Text,Embedding) VALUES ({Id},{index}, \'{Chunks[index]}\', TO_VECTOR(\'{vector_string}\',FLOAT))'
        
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
  <MapItem MessageType="Demo.Operations.Embedding.EmbeddingRequest">
    <Method>OnGetEmbeddings</Method>
  </MapItem>
</MapItems>
}

}
