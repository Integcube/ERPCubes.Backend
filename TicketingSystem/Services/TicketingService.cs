using System.Collections.Generic;
using System.Linq;

namespace TicketingSystem.Services
{
    public class TicketingService
    {
        private static readonly Dictionary<string, Dictionary<string, string>> TenantUserConnections = new Dictionary<string, Dictionary<string, string>>();
        private static readonly Dictionary<string, Dictionary<string, string>> BrowserUserConnections = new Dictionary<string, Dictionary<string, string>>();

        public bool AddUserToList(string tenantId, string userToAdd)
        {
            lock (TenantUserConnections)
            {
                if (!TenantUserConnections.ContainsKey(tenantId))
                {
                    TenantUserConnections[tenantId] = new Dictionary<string, string>();
                }
                var users = TenantUserConnections[tenantId];
                if (users.ContainsKey(userToAdd.ToLower()))
                {
                    return false;
                }
                users.Add(userToAdd.ToLower(), null);
                return true;
            }
        }

        public void AddUserConnectionId(string tenantId, string user, string connectionId)
        {
            lock (TenantUserConnections)
            {
                if (TenantUserConnections.ContainsKey(tenantId))
                {
                    var users = TenantUserConnections[tenantId];
                    if (users.ContainsKey(user.ToLower()))
                    {
                        users[user.ToLower()] = connectionId;
                    }
                }
            }
        }

        public string GetUserByConnectionId(string connectionId)
        {
            lock (TenantUserConnections)
            {
                foreach (var users in TenantUserConnections.Values)
                {
                    var user = users.FirstOrDefault(x => x.Value == connectionId);
                    if (!string.IsNullOrEmpty(user.Key))
                    {
                        return user.Key;
                    }
                }
                return null;
            }
        }

        public string GetConnectionIdByUser(string tenantId, string user)
        {
            lock (TenantUserConnections)
            {
                if (TenantUserConnections.ContainsKey(tenantId))
                {
                    var users = TenantUserConnections[tenantId];
                    return users.ContainsKey(user.ToLower()) ? users[user.ToLower()] : null;
                }
                return null;
            }
        }

        public void RemoveUserFromList(string tenantId, string user)
        {
            lock (TenantUserConnections)
            {
                if (TenantUserConnections.ContainsKey(tenantId))
                {
                    var users = TenantUserConnections[tenantId];
                    if (users.ContainsKey(user.ToLower()))
                    {
                        users.Remove(user.ToLower());
                    }
                }
            }
        }

        public string[] GetOnlineUsers(string tenantId)
        {
            lock (TenantUserConnections)
            {
                if (TenantUserConnections.ContainsKey(tenantId))
                {
                    return TenantUserConnections[tenantId].OrderBy(x => x.Key).Select(x => x.Key).ToArray();
                }
                return new string[0];
            }
        }
    }
}
