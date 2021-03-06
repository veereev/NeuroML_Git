<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>

<%@page import="org.neuroml.validator.utils.*"%>
<%@page import="java.util.*"%>
<%@page import="java.io.*"%>
<%@page import="java.net.*"%>
<%@page import="org.neuroml.validator.utils.*"%>
<%@page import="org.neuroml.validator.validation.*"%>
<!--------

File:      Extending.jsp
Author:    Padraig Gleeson

           This file has been developed as part of the neuroConstruct project
           This work has been funded by the Medical Research Council

---------->
<html>
    <head>
        <link rel="stylesheet" type="text/css" href="application.css" />    
<script type="text/javascript" src="http://spike.la.asu.edu/NeuroMLValidator/public/javascripts/jquery-1.7.1.min.js"></script>
  <script type="text/javascript" src="http://spike.la.asu.edu/NeuroMLValidator/public/javascripts/jquery.dropotron-1.0.js"></script>
<script type="text/javascript">
var j = jQuery.noConflict();
      j(function() {
          j('#menu > ul').dropotron({
              mode: 'fade',
              globalOffsetY: 11,
              offsetY: -15
          });
      });
  </script>
        <title>Extending NeuroML</title></head>
        <%GeneralUtils.setCurrentPageRef("extend");%>
    <body>
    <div id="wrapper">
        <%@ include file="header.jsp" %>
        
<div class="overflowcontent">
        <h1>Extending NeuroML</h1>

        <p>One of the most frequently asked questions we get is: How can I extend NeuroML to support my model?</p>

        <p>The following information is intended to clarify the various options which are available at present
            and outline the procedures for incorporating native support for new model features into NeuroML.</p>

        <h2>Clarifying the question</h2>

        <p>NeuroML is intended to be an open and evolving language which will increase in scope with time. It is however a model description language which is built on
        a number of key concepts commonly used in biophysically detailed computational neuroscience modelling (neuronal morphologies, ion channels, synaptic connections)
        and provides a way to represent these entities in a structured language which can be used by applications which also deal with these physiological entities.</p>

        <p>This has the advantage of providing an efficient way to represent the key elements of models which can be exchanged between applications and researchers
            (e.g. without needing the Hodgkin Huxley model to be redefined in full for every channel). This approach is different to that of languages like <a href="http://www.sbml.org">SBML</a> and <a href="http://www.cellml.org">CellML</a> where more generic
            dynamical (biological) model systems can be described in terms of interacting entities and rates of change of variables. While a multicompartment cell with 
            multiple ion channels can be expressed in one of these languages, it would be difficult to extract the key neuroscience elements out of them in a
            standardised way, or to simulate the models as efficiently as a dedicated compartmental modelling simulator could.</p>
             
        <p>While the approach of SBML and CellML has some clear advantages, in particular the flexibility afforded for developing custom models, the benefits of the current approach with NeuroML
            (ease of portability and efficiency of simulations) have driven the developments in the initiative to date. It does mean however that if a concept is not present in NeuroML
            (e.g. a firing rate model of a neuron; a voltage dependent gap junction) it is more difficult to express that type of model in "pure" NeuroML</p>

        <p>The list below gives a number of options for those who wish to use NeuroML but find that some features of their models are not currently natively supported in the language.</p>


        <ul>
            <li><a href="#annotate">Annotate NeuroML files with model/application specific data</a></li>
            <li><a href="#subset">Create models with a subset of components in NeuroML</a></li>
            <li><a href="#domain_schema">Create a domain specific schema</a></li>
            <li><a href="#extend_v1.0">Propose extensions to current version of NeuroML</a></li>
            <li><a href="#extend_v2.0">Propose major changes for NeuroML v2.0</a></li>
        </ul>



        <p>If there are additional scenarios which also need to be included/discussed please get in touch via the <a href="http://sourceforge.net/mail/?group_id=136437">mailing lists</a>. </p>
        


        <br/>
        <a name="annotate"></a>
        <h2>Annotate files with model/application specific data</h2>

        <p>There are multiple ways to add metadata to a NeuroML file. While much of the metadata that can be added is in the form of text strings to explain
            the contents to humans, it is also possible to add more structured data which can give the model developer's own tools (or a subset of similar tools)
            extra information about how to visualise/simulate the model.</p>

        <p>This has the advantage that the files remain "pure" NeuroML, and another application can simply ignore the metadata and only use the core NeuroML infomation
            contained in the file. This is the case with a number of SBML compliant applications, e.g. <a href="http://www.celldesigner.org">CellDesigner</a>
            which uses annotation blocks in the SBML file to add application specific data on its graphical layout of species, compartments, etc.</p>
        
        <p>If a number of applications start using structured metadata for the same types of data, the core language could be updated to support those concepts
            (or a new separate language created, as in the case of <a href="http://sbgn.org">SBGN</a>).</p>

        <p>An example of using metadata in a NeuroML file is the annotation of <a href="http://www.neuroconstruct.org/docs/neuroml.html#Level+3+NeuroML">
                Level 3 NeuroML files exported by neuroConstruct</a>. Information is included in a <b>&lt;meta:annotation&gt;</b> tag which will
                contains all of the information needed to create a new neuroConstruct project from the NeuroML file, includign non core NeuroML information
                such as the colours of cell populations, <a href="http://www.neuroconstruct.org/docs/Glossary_gen.html#Simulation%20Configuration">simulation configurations</a> etc.
        This information can be ignored by other applications which just use the cell and network information.</p>


        <p>The <a href="Latest.jsp?spec=Metadata#metadata">metadata group of elements</a> in the
            <a href="Latest.jsp?spec=Metadata">Metadata schema</a> provides a useful set of base elements for this type of extra data. 
            The following presents examples of some options for adding custom metadata to a NeuroML file:</p>

        <a name="ExtendNetSpec.xml"/>
        <table border =0 bgcolor="#F3F3F3" width ="70%" cellpadding=5 style="font-family: system">
            <tr><td><p><%

    XMLFile fileToView = new XMLFile();
    fileToView.setXMLFile(application.getRealPath("NeuroMLFiles/Examples/NetworkML/ExtendNetSpec.xml"));
    out.println(fileToView.toHTMLString(true, true, 19, 99));




                    %></p>
                </td>
            </tr>
        </table>

        <p>The example below shows how to embed a custom model into an existing element in NeuroML. This allows a modeller to encode a
        new model in valid NeuroML. Note that if a simulator which doesn't support the extension it will produce different results. If multiple
        users require the same types of custom extensions they can be incorporated into the core language.</p>

        <table border =0 bgcolor="#F3F3F3" width ="70%" cellpadding=5 style="font-family: system">
            <tr><td><p><%

    fileToView = new XMLFile();
    fileToView.setXMLFile(application.getRealPath("NeuroMLFiles/Examples/NetworkML/ExtendNetSpec.xml"));
    out.println(fileToView.toHTMLString(true, true, 120, 140));




                    %></p>
                </td>
            </tr>
        </table>

        <p>The full NeuroML file can be viewed <a href="ViewNeuroMLFile.jsp?localFile=NeuroMLFiles/Examples/NetworkML/ExtendNetSpec.xml">here</a>.</p>







        <br/>
        <a name="subset"></a>
        <h2>Create models with a subset of components in NeuroML</h2>

        <p>While there are a number of model types which are currently supported in NeuroML, and while a number of
            cell and network models can be fully expressed in NeuroML (see <a href="http://www.neuroml.org/models.php">here</a>) some
            components of a cell model might not be supported in the current version of the language (e.g. a custom channel type created with NMODL for NEURON).
        </p>
        <p>If these types of models are sufficiently widely used they can be incorporated into the language (see <a href="#extend_v1.0">below</a>),
            but it can take some time for the updates to be made. </p>

        <p>NeuroML is intended to be just one of many tools used in the computational modelling pipeline of data acquisition/model creation/simulation/analysis/publication/reuse.
            It won't be the case that full specification in NeuroML will be possible (or desirable) for every model, and the choice of model
            specification language will be a trade off between the amount of flexibility required and how much the various model elements fit into
            NeuroML's data model of common neurophysiolgical entities (or another standardised representation):
        </p>
        
        <p align="center"><img alt="Flexibility vs. standardisation" src="images/simopts2.png" align="middle"/></p>

        <p> Some of the options for model specification which mix NeuroML and native scripts include:  </p>
            <ul>
                <li>The native NeuroML import function (e.g. <a href="tool_support.php#NEURON">NEURON</a>, <a href="tool_support.php#PSICS">PSICS</a>) of 
                    the application can be used for the NeuroML based model components and the "traditional" script format for the rest of the model. 
                    The example file presented <a href="#ExtendNetSpec.xml">in the previous section</a> shows how a channel in a native simulator script
                    (Na_Channel_NMODL) could be referenced in a valid Level 2 cell description.</li><br>

                <li>A number of channels can be expressed in ChannelML and (Python) scripts used to convert these to native simulator format
                    (e.g. see <a href="../neuron_tools.php">"Conversion of ChannelML at the command line"</a>) before including them as normal in a native simulation script</li><br>

                <li>Cell models developed in neuroConstruct can transparently mix ChannelML and native <a href="../neuron_tools.php">File based Cell Mechanisms</a></li><br>
            </ul>

        <p>These options have the advantage that the components of the model which are in NeuroML can be readily reused by other researchers.</p>



        <br/>

        <a name="domain_schema"></a>
        <h2>Create a domain specific schema</h2>

        <p>This method is appropriate if you have a new class of data structures for which you need a defined specification, but want to reuse a number of
        NeuroML elements. An example would be if you want to define models which have neuronal elements but also concepts outside of the current scope of NeuroML,
        e.g. the 3D shape of blood vessels and blood flow; detailed electrical probes with 3D extent; interaction of neuropil with external electrical fields.</p>

        <p>This can be accomplished by defining a new schema and including the existing NeuroML <a href="../specifications.php">schemas</a> as appropriate.</p>

        <p>In the example below <i>"VasculatureML"</i> is defined. This new dummy language is intended to incorporate models of both neurons and vasculature.</p>
        
        <p>Schema of the new language: </p>

        <table border =0 bgcolor="#F3F3F3" width ="70%" cellpadding=5 style="font-family: system">
            <tr><td><p><%

    fileToView.setXMLFile(application.getRealPath("docs/VasculatureML.xsd"));
    out.println(fileToView.toHTMLString(false, true));




                    %></p>
                </td>
            </tr>
        </table>
        
        <p>Example of typical <i>"VasculatureML"</i> file: </p>

        <table border =0 bgcolor="#F3F3F3" width ="70%" cellpadding=5 style="font-family: system">
            <tr><td><p><%

    fileToView.setXMLFile(application.getRealPath("docs/ExtendedToVasc.xml"));
    out.println(fileToView.toHTMLString(true, true));




                    %></p>
                </td>
            </tr>
        </table>

        <p>This approach has the advantage that communities focusing on a specific domain can define and update their schemas independent of
            the NeuroML initiative and reuse only the elements of this language that are appropriate.<p>

        <p>It also means that the neuronal elements of this new language can be easily extracted and used in a NeuroML only application.<p>

        <p>If there are any communities taking this approach (or planning to) we'd love to <a href="../contacts.php">hear about it</a>.<p>




            
        <br/>
        <a name="extend_v1.0"></a>

        <h2>Propose extensions to current version of NeuroML</h2>

        <p>While work is already started defining the scope of <a href="../roadmap.php">NeuroML version 2.0</a>, it it still possible that
            some minor extensions could be incorporated into the existing version v1.x schemas. General requirements for making additions to the language
            this at this stage would include:
            <ul>
                <li>The model element can be expressed relatively easily in one (ideally two or more) simulators which already support NeuroML</li>
                <li>Executable examples of the model elements are available</li>
                <li>Published models exist using the model element in the simulator(s)</li>
                <li>The extension would not require restructuring to any of the existing elements (i.e. making present NeuroML files invalid)</li>
            </ul>
        <p>

        <p>Most of these types of extensions would involve minor alterations to existing elements for subcases which weren't built in initially, e.g.
            allowing the <a href="http://www.neuroml.org/NeuroMLValidator/ViewNeuroMLFile.jsp?localFile=NeuroMLFiles/Examples/ChannelML/GateDepQ10.xml">q10 factor to be expressed independently per gate</a>.</p>

        <p>Other adjustments which are currently planned include allowing a table of experimental data to be used for gating variables
            (see <a href="http://sourceforge.net/mailarchive/message.php?msg_name=4B4DFC72.8010607%40ucl.ac.uk">here</a>, planned for v1.8.2).</p>

        <p>Anyone who identifies such an extension should get in contact via the <a href="http://sourceforge.net/mailarchive/forum.php?forum_name=neuroml-technology">neuroml-technology</a>
       mailing list. While it has mainly been members of the NeuroML Team who have been active in implementing changes, proposers of new features are encouraged to supply
        example simulator code and even suggest a new form of the appropriate NeuroML schema incorporating the change.</p>



        

        <br/>
        <a name="extend_v2.0"></a>
        <h2>Propose major changes for NeuroML v2.0</h2>

        <p>New types of model which require major changes to the language (or restructuring of the existing elements)
            will have to wait for NeuroML version 2.0.</p>

        <p>The scope of version 2.0 will encompass all models currently supported in the language and allow new and more complex
            models to be produced with greater detail on subcellular signalling pathways and more complex network creation algorithms.
            The changes which are planned to date were discussed at the
            <a href="http://math.la.asu.edu/~cans/workshop.html">second NeuroML Development Workshop</a>.
            The minutes for that meeting and information on future plans will be posted on the page for the

            <a href="../roadmap.php">roadmap to NeuroML version 2.0</a>.

        <p>Once concrete proposals for the new form of NeuroML are created, we will be seeking feedback from the wider
            computational neuroscience community on the proposed extensions, so join the <a href="../mailing_list.php">mailing list</a>!</p>

        <p>&nbsp;</p>
        <p>&nbsp;</p>
        <p>&nbsp;</p>
       <%@ include file="footer.jsp" %>
      
      </div></div>
       
        </div></div>
    </body>
</html>
