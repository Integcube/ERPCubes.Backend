﻿
using ERPCubes.Application.Features.Crm.DocumentLibrary.Command.AddDocument;
using ERPCubes.Application.Features.Crm.DocumentLibrary.Command.AddFile;
using ERPCubes.Application.Features.Crm.DocumentLibrary.Command.AddLeadFile;
using ERPCubes.Application.Features.Crm.DocumentLibrary.Command.DeleteDocument;
using ERPCubes.Application.Features.Crm.DocumentLibrary.Command.UpdateDocumentCommand;
using ERPCubes.Application.Features.Crm.DocumentLibrary.Queries.GetDocumentLibrary;
using ERPCubes.Identity.Models;
using ERPCubesApi.Model;
using MediatR;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json;
using Serilog.Sinks.File;
using System.Net.Http;
using System.Text;

namespace ERPCubesApi.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class DocumentLibraryController : ControllerBase
    {

        private readonly IMediator _mediator;
        private readonly IConfiguration _configuration;
        private readonly ILogger<DocumentLibraryController> _logger;
        public DocumentLibraryController(IMediator mediator, IConfiguration configuration, ILogger<DocumentLibraryController> logger)
        {
            _mediator = mediator;
            _configuration = configuration;
            _logger = logger;
        }

        [HttpPost("all", Name = "GetAllDocuments")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<ActionResult<List<GetDocumentLibraryVm>>> GetAllCategories(GetDocumentLibraryQuery getDocument)
        {
            var dtos = await _mediator.Send(getDocument);
            return Ok(dtos);
        }

        [HttpPost("saveFile")]
        public async Task<IActionResult> SaveFile([FromForm] SaveFileDto saveFileDto)
        {
            try
            {
                if (saveFileDto.File == null || saveFileDto.File.Length == 0)
                {
                    return BadRequest("Invalid file");
                }

                using (var memoryStream = new MemoryStream())
                {
                    await saveFileDto.File.CopyToAsync(memoryStream);
                    byte[] fileBytes = memoryStream.ToArray();

                    var directApiBaseUrl = _configuration["AppSettings:FileServerUrl"];
                    if (directApiBaseUrl == null)
                    {
                        _logger.LogError("AppSettings:FileServerUrl is not configured.");
                        return BadRequest("Internal server error.");
                    }

                    var saveFileUrl = $"{directApiBaseUrl}/api/FileManagment/savefile?tenantId={int.Parse(saveFileDto.TenantId)}";

                    using (HttpClient httpClient = new HttpClient())
                    {
                        using (var formData = new MultipartFormDataContent())
                        {
                            var fileContent = new ByteArrayContent(fileBytes);
                            formData.Add(fileContent, "file", saveFileDto.File.FileName);
                            var saveFileResponse = await httpClient.PostAsync(saveFileUrl, formData);
                            saveFileResponse.EnsureSuccessStatusCode();
                            var responseContent = await saveFileResponse.Content.ReadAsStringAsync();
                            dynamic responseObject = JsonConvert.DeserializeObject(responseContent);
                            string extension = responseObject.extension;
                            extension = extension.TrimStart('.').ToUpper();
                            AddDocumentCommand vm = new AddDocumentCommand
                            {
                                Id = saveFileDto.Id,
                                TenantId = int.Parse(saveFileDto.TenantId),
                                Document = new AddDocumentCommandVm
                                {
                                    FileId = -1,
                                    FileName = responseObject.originalFileName,
                                    Description = "",
                                    Type = extension,
                                    Path = responseObject.withoutExtension,
                                    ParentId = int.Parse(saveFileDto.ParentId),
                                    Size = responseObject.fileSize,
                                    CreatedDate = DateTime.UtcNow,
                                    CreatedBy = saveFileDto.Id
                                },

                            };
                            var dtos = await _mediator.Send(vm);
                            return Ok(dtos);
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                _logger.LogError($"Error during file upload: {ex.Message}");
                return StatusCode(500, $"Internal server error: {ex.Message}");
            }
        }

        [HttpPost("addLeadFile")]
        public async Task<IActionResult> AddLeadFile([FromForm] AddLeadFileDto addLeadFileDto)
        {
            try
            {
                if (addLeadFileDto.File == null || addLeadFileDto.File.Length == 0)
                {
                    return BadRequest("Invalid file");
                }

                using (var memoryStream = new MemoryStream())
                {
                    await addLeadFileDto.File.CopyToAsync(memoryStream);
                    byte[] fileBytes = memoryStream.ToArray();

                    var directApiBaseUrl = _configuration["AppSettings:FileServerUrl"];
                    if (directApiBaseUrl == null)
                    {
                        _logger.LogError("AppSettings:FileServerUrl is not configured.");
                        return BadRequest("Internal server error.");
                    }

                    var saveFileUrl = $"{directApiBaseUrl}/api/FileManagment/savefile?tenantId={int.Parse(addLeadFileDto.TenantId)}";

                    using (HttpClient httpClient = new HttpClient())
                    {
                        using (var formData = new MultipartFormDataContent())
                        {
                            var fileContent = new ByteArrayContent(fileBytes);
                            formData.Add(fileContent, "file", addLeadFileDto.File.FileName);
                            var saveFileResponse = await httpClient.PostAsync(saveFileUrl, formData);
                            saveFileResponse.EnsureSuccessStatusCode();
                            var responseContent = await saveFileResponse.Content.ReadAsStringAsync();
                            dynamic responseObject = JsonConvert.DeserializeObject(responseContent);
                            string extension = responseObject.extension;
                            extension = extension.TrimStart('.').ToUpper();
                            AddLeadFileCommand vm = new AddLeadFileCommand
                            {
                                Id = addLeadFileDto.Id,
                                TenantId = int.Parse(addLeadFileDto.TenantId),
                                LeadId = int.Parse(addLeadFileDto.LeadId),
                                ContactTypeId = int.Parse(addLeadFileDto.ContactTypeId),
                                File = new AddLeadFileVm
                                {
                                    FileId = -1,
                                    FileName = responseObject.originalFileName,
                                    Description = "",
                                    Type = extension,
                                    Path = responseObject.withoutExtension,
                                    ParentId = int.Parse(addLeadFileDto.ParentId),
                                    Size = responseObject.fileSize,
                                    Id = int.Parse(addLeadFileDto.LeadId),
                                    ContactTypeId = int.Parse(addLeadFileDto.ContactTypeId),
                                    CreatedDate = DateTime.UtcNow,
                                    CreatedBy = addLeadFileDto.Id
                                },
                            };
                            var dtos = await _mediator.Send(vm);
                            return Ok(dtos);
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                _logger.LogError($"Error during file upload: {ex.Message}");
                return StatusCode(500, $"Internal server error: {ex.Message}");
            }
        }


        [HttpGet("getfile")]
        public async Task<IActionResult> ReturnFile(string filePath)
        {
            try
            {
                var saveFileUrl = $"{_configuration["AppSettings:FileServerUrl"]}/api/FileManagment/getfile?filePath={Uri.EscapeDataString(filePath)}";


                using (HttpClient httpClient = new HttpClient())
                {
                    var response = await httpClient.GetAsync(saveFileUrl);
                    response.EnsureSuccessStatusCode();

                    var fileBytes = await response.Content.ReadAsByteArrayAsync();
                    var fileStream = new MemoryStream(fileBytes);

                    return File(fileStream, "application/octet-stream", Path.GetFileName(filePath));
                }
            }
            catch (Exception ex)
            {
                return StatusCode(500, $"Unexpected error: {ex.Message}");
            }
        }


        [HttpPost("update", Name = "UpdateDocument")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<ActionResult> UpdateDocument(UpdateDocumentCommand updateDocument)
        {
            var dtos = await _mediator.Send(updateDocument);
            return Ok(dtos);
        }

        [HttpPost("addFolder", Name = "AddFolder")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<ActionResult> AddFolder(AddFileCommand addFile)
        {
            var dtos = await _mediator.Send(addFile);
            return Ok(dtos);
        }

        [HttpPost("delete", Name = "DeleteDocument")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<ActionResult> DeleteDocument(DeleteDocumentCommand deleteDocument)
        {
            var dtos = await _mediator.Send(deleteDocument);
            return Ok(dtos);
        }
    }
}
