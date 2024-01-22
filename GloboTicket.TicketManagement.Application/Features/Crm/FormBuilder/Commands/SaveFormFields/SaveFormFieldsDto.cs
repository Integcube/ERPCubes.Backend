using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.FormBuilder.Commands.SaveFormFields
{
    public class SaveFormFieldsDto
    {
        public int FieldId { get; set; }
        public int FormId { get; set; }
        public string FieldLabel { get; set; } = string.Empty;
        public int FieldType { get; set; }
        public string? Placeholder { get; set; } = string.Empty;
        public string? Values { get; set; } = string.Empty;
        public string? Result {  get; set; } = string.Empty;
        public Boolean IsFixed { get; set; }
        public int Order { get; set; }
        public Boolean DisplayLabel { get; set; }
        public string? CSS { get; set; } = string.Empty;
    }
}
