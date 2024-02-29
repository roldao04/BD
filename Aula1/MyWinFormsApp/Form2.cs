using System;
using System.Windows.Forms;
using System.Drawing;
using System.Data;
using System.Data.SqlClient;

public class Form2 : Form
{
    private TextBox serverTextBox;
    private TextBox userTextBox;
    private TextBox passwordTextBox;
    private Button testConnectionButton;
    private Button helloTableButton;

    public Form2()
    {
        this.Text = "Aula 1 BD";
        this.Size = new Size(400, 300);

        serverTextBox = new TextBox { Location = new Point(100, 20), Size = new Size(250, 20) };

        userTextBox = new TextBox { Location = new Point(100, 50), Size = new Size(250, 20) };

        passwordTextBox = new TextBox { Location = new Point(100, 80), Size = new Size(250, 20), UseSystemPasswordChar = true };

        testConnectionButton = new Button { Text = "Test Ligação", Location = new Point(10, 110), Size = new Size(120, 40) };
        testConnectionButton.Click += TestConnectionButton_Click;

        helloTableButton = new Button { Text = "Hello Table", Location = new Point(140, 110), Size = new Size(120, 40) };
        helloTableButton.Click += HelloTableButton_Click;

        Controls.Add(new Label { Text = "Server", Location = new Point(10, 20), Size = new Size(80, 20) });
        Controls.Add(serverTextBox);
        Controls.Add(new Label { Text = "User", Location = new Point(10, 50), Size = new Size(80, 20) });
        Controls.Add(userTextBox);
        Controls.Add(new Label { Text = "Password", Location = new Point(10, 80), Size = new Size(80, 20) });
        Controls.Add(passwordTextBox);
        Controls.Add(testConnectionButton);
        Controls.Add(helloTableButton);
    }

    private void InitializeComponent() 
    {
       // Initialize Test Connection button
        testConnectionButton = new Button
        {
            Text = "Test Ligação",
            Location = new Point(10, 100), // Adjust the location as needed
            Size = new Size(120, 30)
        };
        testConnectionButton.Click += TestConnectionButton_Click; // Assign the event handler
        this.Controls.Add(testConnectionButton); // Add the button to the form

        // Initialize Hello Table button
        helloTableButton = new Button
        {
            Text = "Hello Table",
            Location = new Point(140, 100), // Adjust the location as needed
            Size = new Size(120, 30)
        };
        helloTableButton.Click += HelloTableButton_Click; // Assign the event handler
        this.Controls.Add(helloTableButton); // Add the button to the form
    }

    // Event handler for testing database connection
    private void TestConnectionButton_Click(object sender, EventArgs e)
    {
        // Replace with actual values or references to text boxes for user input
        string server = serverTextBox.Text;
        string database = "master"; // Replace with the actual database name
        string username = userTextBox.Text;
        string password = passwordTextBox.Text;
        TestDBConnection(server, database, username, password);
    }

    // Event handler for displaying content from the Hello table
    private void HelloTableButton_Click(object sender, EventArgs e)
    {
        // Replace with actual values or references to text boxes for user input
        string server = serverTextBox.Text;
        using (SqlConnection connection = new SqlConnection($"Data Source={server};Initial Catalog=master;Integrated Security=True"))
        {
            try
            {
                connection.Open();
                string content = GetTableContent(connection);
                MessageBox.Show(content); // Show the content in a message box or assign it to a text control
            }
            catch (Exception ex)
            {
                MessageBox.Show($"An error occurred: {ex.Message}");
            }
        }
    }

    private void TestDBConnection(string dbServer, string dbName, string userName, string userPass)
        {
            SqlConnection CN = new SqlConnection("Data Source = " + dbServer + " ;" + "Initial Catalog = " + dbName + 
                                                       "; uid = " + userName + ";" + "password = " + userPass);
            
            try
            {
                CN.Open();
                if (CN.State == ConnectionState.Open)
                {
                    MessageBox.Show("Successful connection to database " + CN.Database + " on the " + CN.DataSource + " server",  "Connection Test", MessageBoxButtons.OK);
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show("Failed to open connection to database due to the error \r\n" + ex.Message, "Connection Test", MessageBoxButtons.OK);
            }

            if (CN.State == ConnectionState.Open)
                CN.Close();
        }


        private string GetTableContent(SqlConnection CN)
        {
            string str = "";
         
            try
            {
                CN.Open();
                if (CN.State == ConnectionState.Open)
                {
                    int cnt = 1;
                    SqlCommand sqlcmd = new SqlCommand("SELECT * FROM Hello", CN);
                    SqlDataReader reader;
                    reader = sqlcmd.ExecuteReader();

                    while (reader.Read())
                    {
                        str += cnt.ToString() + " - " + reader.GetInt32(reader.GetOrdinal("MsgID")) + ", ";
                        str += reader.GetString(reader.GetOrdinal("MsgSubject"));
                        str += "\n";
                        cnt += 1;
                    }
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show("Failed to open connection to database due to the error \r\n" + ex.Message, "Connection Error", MessageBoxButtons.OK);
            }

            if (CN.State == ConnectionState.Open)
                CN.Close();        

            return str;
        }
}
