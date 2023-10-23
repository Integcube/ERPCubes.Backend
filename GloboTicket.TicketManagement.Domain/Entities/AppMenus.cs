using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Domain.Entities
{
    public class AppMenus
    {
        [Key]
        public int MenuId { get; set; }
        public string Code { get; set; } = string.Empty;
        public string Title { get; set; } = string.Empty;
        public string? Subtitle { get; set; } = string.Empty;
        public string? Type { get; set; } = string.Empty;
        public string? Icon { get; set; } = string.Empty;
        public string? Link { get; set; } = string.Empty;
        public string? Level { get; set; } = string.Empty;
        public int ParentId { get; set; }
    }
}
