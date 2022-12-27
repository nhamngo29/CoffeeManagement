using System.Data;

namespace DTO
{
    public class Food
    {
        public int ID { get; set; }
        public string Name { get; set; }
        public int TypeID { get; set; }
        public int Price { get; set; }

        public Food(string name, int TypeID, int price)
        {
            this.Name = name;
            this.TypeID = TypeID;
            this.Price = price;
        }

        public Food(int id, string name, int TypeID, int price)
        {
            this.ID = id;
            this.Name = name;
            this.TypeID = TypeID;
            this.Price = price;
        }

        public Food(DataRow row)
        {
            this.ID = (int)row["ID"];
            this.Name = row["Name"].ToString();
            this.TypeID = (int)row["Type"];
            this.Price = (int)row["Price"];
        }
    }
}