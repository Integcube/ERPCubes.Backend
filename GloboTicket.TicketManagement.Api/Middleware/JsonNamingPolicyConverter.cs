using System.Text.Json;

namespace ERPCubesApi.Middleware
{
    public class JsonNamingPolicyConverter : JsonNamingPolicy
    {
        public override string ConvertName(string name)
        {
            // Implement the logic for converting PascalCase to CamelCase or vice versa
            // You can use the same logic mentioned in the previous answer.

            // For example, converting PascalCase to CamelCase:
            return char.ToLower(name[0]) + name.Substring(1);
        }
    }
}
