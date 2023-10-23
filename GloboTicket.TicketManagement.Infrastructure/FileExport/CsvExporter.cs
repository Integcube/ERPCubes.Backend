//using CsvHelper;
//using ERPCubes.Application.Contracts.Infrastructure;
//using ERPCubes.Application.Features.Events.Queries.GetEventsExport;

//namespace ERPCubes.Infrastructure.FileExport
//{
//    public class CsvExporter : ICsvExporter
//    {
//        public byte[] ExportEventsToCsv(List<EventExportDto> eventExportDtos)
//        {
//            using var memoryStream = new MemoryStream();
//            using (var streamWriter = new StreamWriter(memoryStream))
//            {
//                using var csvWriter = new CsvWriter(streamWriter);
//                csvWriter.WriteRecords(eventExportDtos);
//            }

//            return memoryStream.ToArray();
//        }
//    }
//}
