using System.Drawing;
using System.Windows.Forms;

namespace MyWinFormsApp
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();

            // Create a button and set its properties
            Button button = new Button
            {
                Size = new Size(100, 40),
                Location = new Point(10, 10),
                Text = "Click Me"
            };

            // Create a checkbox and set its properties
            CheckBox checkBox = new CheckBox
            {
                Size = new Size(100, 40),
                Location = new Point(10, 60),
                Text = "Check Me"
            };

            // Create a label and set its properties
            Label label = new Label
            {
                Size = new Size(100, 40),
                Location = new Point(10, 110),
                Text = "Label Text"
            };

            // Create a textbox and set its properties
            TextBox textBox = new TextBox
            {
                Size = new Size(100, 40),
                Location = new Point(10, 160)
            };

            // Create a listbox and set its properties
            ListBox listBox = new ListBox
            {
                Size = new Size(100, 40),
                Location = new Point(10, 210)
            };
            listBox.Items.Add("Item 1");
            listBox.Items.Add("Item 2");
            listBox.Items.Add("Item 3");

            // Add the controls to the form
            Controls.Add(button);
            Controls.Add(checkBox);
            Controls.Add(label);
            Controls.Add(textBox);
            Controls.Add(listBox);
        }
    }
}
