using Dynamicweb.Indexing;
using Dynamicweb.Indexing.Schemas;
using System.Collections.Generic;

namespace TechConference2015
{
    public class UserSchemaExtender : IIndexSchemaExtender
    {
        public IEnumerable<FieldDefinitionBase> GetFields()
        {
            var result = new List<FieldDefinitionBase>
            {
                #region Field definitions
                new FieldDefinition
                {
                    Name = "User ID",
                    SystemName = "UserID",
                    Source = "AccessUserID",
                    Type = "System.Int32",
                    Stored = true,
                    Indexed = true,
                    Analyzed = false
                },
                #region More fields
                new FieldDefinition
                {
                    Name = "User name",
                    SystemName = "UserName",
                    Source = "AccessUserUserName",
                    Type = "System.String",
                    Stored = true,
                    Indexed = true,
                    Analyzed = false
                },
                new FieldDefinition
                {
                    Name = "Name",
                    SystemName = "Name",
                    Source = "AccessUserName",
                    Type = "System.String",
                    Stored = true,
                    Indexed = true,
                    Analyzed = false
                },
                new FieldDefinition
                {
                    Name = "User e-mail",
                    SystemName = "UserEmail",
                    Source = "AccessUserEmail",
                    Type = "System.String",
                    Stored = true,
                    Indexed = true,
                    Analyzed = false
                },
                new FieldDefinition
                {
                    Name = "Can send e-mail",
                    SystemName = "UserEmailAllowed",
                    Source = "AccessUserNewsletterAllowed",
                    Type = "System.Boolean",
                    Stored = true,
                    Indexed = true,
                    Analyzed = false
                },
                new FieldDefinition
                {
                    Name = "Groups",
                    SystemName = "Groups",
                    Source = "Groups",
                    Type = "System.Int32[]",
                    Stored = true,
                    Indexed = true,
                    Analyzed = false
                }
                #endregion
                #endregion
            };

            return result;
        }
    }
}
