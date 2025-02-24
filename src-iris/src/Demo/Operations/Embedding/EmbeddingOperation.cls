Class Demo.Operations.Embedding.EmbeddingOperation Extends Ens.BusinessOperation
{

Property ChunkSize As %Integer;

Property ChunkOverlap As %Integer;

Parameter SETTINGS = "ChunkSize:Text Chunking,ChunkOverlap:Text Chunking";

Method OnGetEmbeddings(pRequest As Demo.Operations.Embedding.EmbeddingRequest, pResponse As Demo.Operations.Embedding.EmbeddingResponse) As %Status
{

    Set tSc = $$$OK

    Try{

        Set tId = pRequest.Pdf
        Set tPdf = ##class(Demo.PDFRecord).%OpenId(tId)
        Set tChunks = ##class(Demo.Utils).GetChunks(tPdf.Text, ..ChunkSize, ..ChunkOverlap)         
        // set tVectors = ##class(Demo.Utils).GetEmbeddingPy(tChunks)
        For i=0:1:(tChunks."__len__"()-1) {
            Set tChunk = tChunks."__getitem__"(i)
            Set tRecordId = i
            &sql(INSERT INTO Demo.RecordEmbeddings (DataSourceId,SourceId,Text) VALUES (:tId,:tRecordId,:tChunk))
        }
        Set pResponse = ##class(Demo.Operations.Embedding.EmbeddingResponse).%New()
        Set pResponse.NumberEmbeddings = tChunks."__len__"()
    }
    Catch tEx {
        Set tSc = tEx.AsStatus()
    }
    
    Return tSc
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
