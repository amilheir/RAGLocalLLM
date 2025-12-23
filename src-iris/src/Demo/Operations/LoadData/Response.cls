Class Demo.Operations.LoadData.Response Extends (%Persistent, Ens.Response)
{

Property NumberEmbeddings As %Integer;

Storage Default
{
<Data name="ResponseDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>NumberEmbeddings</Value>
</Value>
</Data>
<DataLocation>^Demo.Operations.LFBA5.ResponseD</DataLocation>
<DefaultData>ResponseDefaultData</DefaultData>
<IdLocation>^Demo.Operations.LFBA5.ResponseD</IdLocation>
<IndexLocation>^Demo.Operations.LFBA5.ResponseI</IndexLocation>
<StreamLocation>^Demo.Operations.LFBA5.ResponseS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
