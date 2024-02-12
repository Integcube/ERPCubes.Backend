using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace FileServer.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class FileManagmentController : ControllerBase
    {
        private const string FileStorageFolder = "files";


        public FileManagmentController()
        {

        }
        [HttpGet]
        public IActionResult Get()
        {
            return Ok("Hello from Project B");
        }

        [HttpPost("savefile")]
        public async Task<IActionResult> SaveFile(IFormFile file, int tenantId)
        {
            try
            {
                if (file == null || file.Length == 0)
                {
                    return BadRequest("Invalid file");
                }

             
                string uniqueFileName = $"{Guid.NewGuid()}_{file.FileName}";

                string fileExtension = Path.GetExtension(file.FileName);

                string filePath = GetFilePath(tenantId, uniqueFileName);
                
                string pathWithoutExtension = Path.Combine(FileStorageFolder, $"Tenant{tenantId}", uniqueFileName).Replace("\\", "/");

                using (var stream = new FileStream(filePath, FileMode.Create))
                {
                    await file.CopyToAsync(stream);
                }
                string relativePath = filePath.Replace("\\", "/");
                var data = new
                {
                    FullPath = filePath,
                    WithoutExtension = pathWithoutExtension,
                    Extension = fileExtension,
                    OriginalFileName =Path.GetFileNameWithoutExtension(file.FileName),
                    FileSize = file.Length
                };

                return Ok(data);
            }
            catch (Exception ex)
            {
                return StatusCode(500, $"Internal server error: {ex.Message}");
            }
        }

        private string GetFilePath(int tenantId, string fileName)
        {
            string directoryPath = Path.Combine(Directory.GetCurrentDirectory(), FileStorageFolder, $"Tenant{tenantId}");

            if (!Directory.Exists(directoryPath))
            {
                Directory.CreateDirectory(directoryPath);
            }

            return Path.Combine(directoryPath, fileName);
        }

        private string GetFilePath(string fileId)
        {

            return Path.Combine(Directory.GetCurrentDirectory(), FileStorageFolder, fileId);
        }


        [HttpGet("getfile")]
        public IActionResult GetFile(string filePath)
        {
            try
            {
                if (string.IsNullOrEmpty(filePath))
                {
                    return BadRequest("Invalid file path");
                }
                string relativePath = filePath.Replace("/", "\\");
                string directoryPath = Path.Combine(Directory.GetCurrentDirectory(), relativePath);

                var fileBytes = System.IO.File.ReadAllBytes(directoryPath);
                var fileName = Path.GetFileName(filePath);

                return File(fileBytes, "application/octet-stream", fileName);
            }
            catch (Exception ex)
            {
                return StatusCode(500, $"Internal server error: {ex.Message}");
            }
        }

    }
}
