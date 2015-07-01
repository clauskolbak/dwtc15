using Dynamicweb.Diagnostics.Tasks;
using Dynamicweb.Indexing;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;

namespace TechConference2015
{
    public class UserIndexBuilder : IIndexBuilder
    {
        public string Action { get; set; }
        public IDictionary<string, string> Meta { get; set; }
        public string Name { get; set; }
        public Dynamicweb.Indexing.Schemas.SchemaDefinition Schema { get; set; }
        public IDictionary<string, string> Settings { get; set; }
        public string Type { get; set; }
        public IEnumerable<IIndexBuilderExtender<IIndexBuilder>> Extenders { get; set; }

        public IEnumerable<string> SupportedActions { get { return new[] { "Full" }; } }

        public void Build(IIndexWriter writer, Dynamicweb.Diagnostics.Tracking.Tracker tracker)
        {
            #region Implementation
            writer.Open(openForAppend:false);

            if (!TaskManager.Context.ContainsKey("Database.ConnectionString"))
                return;

            using (var conn = new SqlConnection(TaskManager.Context["Database.ConnectionString"].ToString()))
            {
                #region Connection
                conn.Open();

                // Get count
                using (var cmd = conn.CreateCommand())
                {
                    tracker.LogInformation("Getting count");
                    cmd.CommandText = "SELECT COUNT(AccessUserID) FROM AccessUser WHERE AccessUserType = 5";
                    tracker.Status.TotalCount = (int) cmd.ExecuteScalar();
                }

                // Handle users
                using (var cmd = conn.CreateCommand())
                {
                    cmd.CommandText =
                        "SELECT AccessUserID, AccessUserUserName, AccessUserName, AccessUserEmail, AccessUserNewsletterAllowed, AccessUserGroups FROM AccessUser WHERE AccessUserType = 5";

                    using (var reader = cmd.ExecuteReader())
                    {
                        tracker.LogInformation("Handling users");

                        while (reader.Read())
                        {
                            #region Build document
                            var doc = new IndexDocument();

                            for (var i = 0; i < reader.FieldCount; i++)
                            {
                                var name = reader.GetName(i);
                                var value = reader.GetValue(i);

                                if (name == "AccessUserGroups")
                                {
                                    #region Handle groups
                                    if (reader.IsDBNull(i))
                                        continue;

                                    var groupIds = value.ToString().Split(new[] {'@'}, StringSplitOptions.RemoveEmptyEntries);

                                    var groupIdList =
                                        groupIds
                                            .Select(id => id.Trim('@'))
                                            .Where(id => !string.IsNullOrEmpty(id))
                                            .Select(int.Parse)
                                            .ToList();

                                    if (groupIdList.Count > 0)
                                        doc.Add("Groups", groupIdList);
                                    #endregion
                                }
                                else
                                {
                                    doc.Add(name, value);
                                }
                            }

                            writer.AddDocument(doc);
                            tracker.IncrementCounter();
                            #endregion
                        }
                    }
                }
                #endregion
            }
            #endregion
        }
    }
}
