Class Demo.DemoProduction Extends Ens.Production
{

XData ProductionDefinition
{
<Production Name="Demo.DemoProduction" TestingEnabled="true" LogGeneralTraceEvents="true">
  <Description></Description>
  <ActorPoolSize>2</ActorPoolSize>
  <Item Name="Embedding Operation" Category="" ClassName="Demo.Operations.Embedding.EmbeddingOperation" PoolSize="5" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="ChunkOverlap">51</Setting>
    <Setting Target="Host" Name="ChunkSize">256</Setting>
    <Setting Target="Host" Name="FailureTimeout">-1</Setting>
  </Item>
  <Item Name="RAG Operation" Category="" ClassName="Demo.Operations.RAG.RAGOperation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Host" Name="FailureTimeout">-1</Setting>
    <Setting Target="Host" Name="NumberOfRetrivals">3</Setting>
  </Item>
  <Item Name="Injection Process" Category="" ClassName="Demo.Processes.InjectionProcess" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="Prompt Operation" Category="" ClassName="Demo.Operations.Prompt.PromptOperation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="Streamlit Service" Category="" ClassName="Demo.Service.StreamlitService" PoolSize="0" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="TargetConfigName">LLM Process Local</Setting>
  </Item>
  <Item Name="Start Audio Import" Category="" ClassName="Demo.Service.CheckAudioFile" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="ArchivePath">/iris-shared/Archieve/</Setting>
    <Setting Target="Adapter" Name="FilePath">/iris-shared/Input/</Setting>
  </Item>
  <Item Name="LLM Operation" Category="" ClassName="Demo.Operations.LlmLocal.APIOperation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Host" Name="Model">smollm2:1.7b</Setting>
    <Setting Target="Host" Name="ChatBotInstructions">You are a helpful assistant that answer questions based on a Context. And must answer only in a format of one or two phrases.</Setting>
    <Setting Target="Host" Name="NumPredict">100</Setting>
    <Setting Target="Host" Name="TopK">10</Setting>
    <Setting Target="Host" Name="TopP">0.5</Setting>
    <Setting Target="Host" Name="Temperature">0.8</Setting>
  </Item>
  <Item Name="LLM Process Local" Category="" ClassName="Demo.Processes.LLMProcessLocal" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
</Production>
}

}
