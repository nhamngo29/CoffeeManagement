using System;
using System.Collections.Generic;
using System.Data;

using DTO;

namespace DAO
{
    public class FoodDAO
    {
        private static FoodDAO instance;

        public static FoodDAO Instance
        {
            get
            {
                if (instance == null)
                    instance = new FoodDAO();
                return FoodDAO.instance;
            }
        }

        private FoodDAO() { }

        public DataTable GetAllFood()
        {
            string query = "SP_GetAllFood";
            try
            {
                return DataProvider.Instance.ExecuteQuery(query);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public DataTable GetListFoodByTypeID(int TypeFoodID)
        {
            string query = "SP_GetListFoodByTypeFoodID @TypeFoodID";
            try
            {
                return DataProvider.Instance.ExecuteQuery(query, new object[] { TypeFoodID });
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public DataTable SearchFoodByName(string name)
        {
            string query = string.Format("SP_SearchFoodByName @Name");
            try
            {
                return DataProvider.Instance.ExecuteQuery(query, new object[] { name });
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public bool InsertFood(Food newFood)
        {
            string query = string.Format("SP_InsertFood @Name , @TypeID , @Price");
            int result;
            try
            {
                result = DataProvider.Instance.ExecuteNonQuery(query,
                    new object[] { newFood.Name, newFood.TypeID, newFood.Price });
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return result > 0;
        }

        public bool UpdateFood(Food food)
        {
            string query = string.Format("SP_UpdateFood @ID , @Name , @TypeID , @Price");
            int result;
            try
            {
                result = DataProvider.Instance.ExecuteNonQuery(query,
                    new object[] { food.ID, food.Name, food.TypeID, food.Price });
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return result > 0;
        }

        public bool DeleteFood(int ID)
        {
            int result;
            try
            {
                result = DataProvider.Instance.ExecuteNonQuery("SP_DeleteFood @ID", new object[] { ID });
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return result > 0;
        }
    }
}