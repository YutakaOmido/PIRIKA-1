/* 
 * Copyright 2014 Igor Maznitsa (http://www.igormaznitsa.com).
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package com.igormaznitsa.prol.easygui;

/**
 * The class implements the dialog window contains the help about the IDE
 * because it is a very specialized auxiliary class, it is not described very
 * precisely
 *
 * @author Igor Maznitsa (igor.maznitsa@igormaznitsa.com)
 */
public class HelpDialog extends javax.swing.JDialog {
  private static final long serialVersionUID = -7171671787513628228L;

  /**
   * Creates new form HelpDialog
   */
  public HelpDialog(final java.awt.Frame parent) {
    super(parent, true);
    initComponents();
    setVisible(true);
  }

  /**
   * This method is called from within the constructor to initialize the form.
   * WARNING: Do NOT modify this code. The content of this method is always
   * regenerated by the Form Editor.
   */
  @SuppressWarnings("unchecked")
  // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
  private void initComponents() {

    scrollTextHelp = new javax.swing.JScrollPane();
    textHelp = new javax.swing.JTextArea();
    buttonClose = new javax.swing.JButton();

    setDefaultCloseOperation(javax.swing.WindowConstants.DISPOSE_ON_CLOSE);
    setTitle("HELP");
    setLocationByPlatform(true);

    textHelp.setEditable(false);
    textHelp.setColumns(20);
    textHelp.setLineWrap(true);
    textHelp.setRows(5);
    textHelp.setText("It is a small editor allows to edit and execute scripts written in Prolog language (the Edinburgh dialect). It has own predicate library and is not fully compatibly with standards. Both the Prolog engine (PROL) and the Editor have been developed by Igor Maznitsa in 2010 in bounds of learning of Prolog language. Since 2014 the sources of the engine has been opened as an OSS project and published under Apache License 2.0 license.\n\nThe utility has 4 windows which have different purposes:\n\n\"The Editor window\"\n---------------------------\nAllows to enter and edit program text.\n\n\"The Dialog window\"\n---------------------------\nAllows to have communication between executing program and a user. If the current goal of the executing program has several variants, then user can get next solution with pressing the ';' key (as the system asks for it) but any other key will be interpreted as a stop event. \nWarning! As a user press the enter key, it simulates '.' pressing and ' ' keys (I made it to avoid writing '.' when the program executes the 'read/1' predicate).\n\n\"The Message window\"\n---------------------------\nThe window shows system messages which are transmitted by the interpreter during  program execution. \n\n\"The Trace window\"\n---------------------------\nThe window shows some trace information about calls and traceable predicates which were marked with the ':-trace(...).' directive at the executing program.");
    textHelp.setWrapStyleWord(true);
    scrollTextHelp.setViewportView(textHelp);

    buttonClose.setIcon(new javax.swing.ImageIcon(getClass().getResource("/com/igormaznitsa/prol/easygui/icons/cross.png"))); // NOI18N
    buttonClose.setText("Close");
    buttonClose.addActionListener(new java.awt.event.ActionListener() {
      public void actionPerformed(java.awt.event.ActionEvent evt) {
        buttonCloseActionPerformed(evt);
      }
    });

    javax.swing.GroupLayout layout = new javax.swing.GroupLayout(getContentPane());
    getContentPane().setLayout(layout);
    layout.setHorizontalGroup(
      layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
      .addComponent(scrollTextHelp, javax.swing.GroupLayout.Alignment.TRAILING, javax.swing.GroupLayout.DEFAULT_SIZE, 590, Short.MAX_VALUE)
      .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, layout.createSequentialGroup()
        .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
        .addComponent(buttonClose, javax.swing.GroupLayout.PREFERRED_SIZE, 148, javax.swing.GroupLayout.PREFERRED_SIZE)
        .addContainerGap())
    );
    layout.setVerticalGroup(
      layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
      .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, layout.createSequentialGroup()
        .addComponent(scrollTextHelp, javax.swing.GroupLayout.DEFAULT_SIZE, 374, Short.MAX_VALUE)
        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
        .addComponent(buttonClose)
        .addContainerGap())
    );

    pack();
  }// </editor-fold>//GEN-END:initComponents

    private void buttonCloseActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_buttonCloseActionPerformed
      dispose();
    }//GEN-LAST:event_buttonCloseActionPerformed

  // Variables declaration - do not modify//GEN-BEGIN:variables
  private javax.swing.JButton buttonClose;
  private javax.swing.JScrollPane scrollTextHelp;
  private javax.swing.JTextArea textHelp;
  // End of variables declaration//GEN-END:variables

}
