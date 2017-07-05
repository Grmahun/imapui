package com.archsystemsinc.pqrs.controller;


import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.List;

import javax.servlet.http.HttpServletResponse;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.archsystemsinc.pqrs.model.TemplateFile;
import com.archsystemsinc.pqrs.service.TemplateFileService;

import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

/**
 * controller class for provider hypothesis, 
 * state wise statistics, and specialty templates
 * 
 * @author Grmahun Redda
 * @since 6/16/2017
 */
@Controller
public class TemplateFileController {
	
	@Autowired
	private TemplateFileService templateFileService;
	
	@RequestMapping(value = "/admin/templates", method = RequestMethod.GET)
	public String getTemplates(final Model model){
		final TemplateFile templateFile = new TemplateFile();
		List<TemplateFile> templateFiles = templateFileService.findAll();
		model.addAttribute("templateFile", templateFile);
		model.addAttribute("templateFiles", templateFiles);
		return "templatefiles";
	}
	
	@RequestMapping(value = "/admin/new-template/", method = RequestMethod.POST)
	public String addTemplate(@ModelAttribute("templateFile") final TemplateFile templateFile, final RedirectAttributes redirectAttributes){
		MultipartFile uploadedFile = null;
		ByteArrayOutputStream outputStreamBuffer = null;
		
		
	  try {
			/*File Upload Code - Start */
			uploadedFile = templateFile.getUploadFile();		
			
			if(uploadedFile != null && !uploadedFile.isEmpty()) {
				InputStream inputStream = uploadedFile.getInputStream();
				templateFile.setUploadedFileName(uploadedFile.getOriginalFilename());
				templateFile.setUploadedFileType(uploadedFile.getContentType());				
				outputStreamBuffer = new ByteArrayOutputStream();
				
				
		        int nRead;
		        byte[] data = new byte[16384];
	
		        while ((nRead = inputStream.read(data, 0, data.length)) != -1) {
		        	outputStreamBuffer.write(data, 0, nRead);
		        }
	
		     outputStreamBuffer.flush();
			}		     
			templateFile.setUploadedFileContent(outputStreamBuffer.toByteArray());
			TemplateFile uploadedTemplateFile = templateFileService.create(templateFile);
			redirectAttributes.addFlashAttribute("success", "success.save.file");
		}catch (Exception e) {			
			e.printStackTrace();
		}
		return "redirect:../templates";
	}
	
	@RequestMapping(value = { "/admin/download-template/{tempId}" }, method = RequestMethod.GET)
    public String downloadTemplate(@PathVariable int tempId, HttpServletResponse response) throws IOException {
		TemplateFile document = templateFileService.findById(Long.valueOf(tempId));
        response.setContentType(document.getUploadedFileType());
        response.setContentLength(document.getUploadedFileContent().length);
        response.setHeader("Content-Disposition","attachment; filename=\"" + document.getUploadedFileName()+"\"");
  
        FileCopyUtils.copy(document.getUploadedFileContent(), response.getOutputStream());
  
        return "redirect:../templates";
    }
	
	@RequestMapping(value = { "/admin/download-templates"}, method = RequestMethod.GET)
    public String downloadAllDocument(HttpServletResponse response) throws IOException {
		List<TemplateFile> templateFiles = templateFileService.findAll();
		
		if(!templateFiles.isEmpty()){
	        // Call the zipFiles method for creating a zip stream.
	        byte[] zip = zipFiles(templateFiles);
			
			response.setContentType("application/zip");
		    response.setContentLength(zip.length);
		    response.setHeader("Content-Disposition","attachment; filename=\"" + "DATA.ZIP"+"\"");
		  
		    FileCopyUtils.copy(zip, response.getOutputStream());
		}
		
		return "redirect:/admin/templates";
	}
	
	@RequestMapping(value = { "/admin/delete-template/{tempId}" }, method = RequestMethod.GET)
    public String deleteDocument(@PathVariable int tempId) {
		templateFileService.deleteById(Long.valueOf(tempId));
        return "redirect:../templates";
    }
	
	@RequestMapping(value = { "/admin/delete-templates"}, method = RequestMethod.GET)
    public String deleteDocuments() {
		List<TemplateFile> templateFiles = templateFileService.findAll();
		for(TemplateFile templateFile : templateFiles){
			templateFileService.deleteById(templateFile.getId());
		}
        return "redirect:/admin/templates";
    }
	
	
	
	/**
     * Compress the given directory with all its files.
     */
    private byte[] zipFiles(List<TemplateFile> templateFiles) throws IOException {
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        ZipOutputStream zos = new ZipOutputStream(baos);
        
        for(TemplateFile document: templateFiles) {            
            zos.putNextEntry(new ZipEntry(document.getUploadedFileName()));  
            zos.write(document.getUploadedFileContent(), 0, document.getUploadedFileContent().length);
            zos.closeEntry();            
        }
        zos.flush();
        baos.flush();
        zos.close();
        baos.close();

        return baos.toByteArray();
    }


}
