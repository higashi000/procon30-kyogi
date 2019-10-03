import javafx.application.Application;
import javafx.scene.Scene;
import javafx.scene.control.Button;
import javafx.scene.layout.GridPane;
import javafx.stage.Stage;
public class Disp_tile extends Application
{
  int x = 20, y = 20;
  private Button[][] bt2 = new Button[x][y];
  @Override
  public void start(Stage stage) throws Exception
  {
    for(int m = 0; m<bt2.length; m++){
      for(int c=0; c<bt2[m].length; c++){
        bt2[m][c] = new Button();
        bt2[m][c].setPrefWidth(45);
        bt2[m][c].setPrefHeight(45);
      }
    }
    GridPane gp = new GridPane();
    for(int m=0; m<bt2.length; m++){
      for(int c=0; c<bt2.length; c++){
        gp.add(bt2[m][c], m, c);
      }
    }
    Scene sc = new Scene(  gp,950, 950);
    stage.setScene(sc);
    stage.setTitle("Display");
    stage.show();
  }
}
