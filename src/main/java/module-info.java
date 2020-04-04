open module de.danielluedecke.Zettelkasten {

    requires java.desktop;
    requires java.logging;
    requires org.apache.commons.lang3;

    requires appframework;
    requires swing.layout;
    requires jdom2;
    requires javabib;
    requires opencsv;
    requires com.formdev.flatlaf;

    exports de.danielluedecke.zettelkasten to appframework;
}
