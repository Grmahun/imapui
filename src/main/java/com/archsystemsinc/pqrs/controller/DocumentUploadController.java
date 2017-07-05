package com.archsystemsinc.pqrs.controller;

import java.io.IOException;
import java.math.BigInteger;
import java.security.Principal;
import java.util.ArrayList;
import java.util.Iterator;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import javax.validation.Valid;

import org.apache.poi.EncryptedDocumentException;
import org.apache.poi.openxml4j.exceptions.InvalidFormatException;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.usermodel.WorkbookFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.archsystemsinc.pqrs.model.DocumentUpload;
import com.archsystemsinc.pqrs.model.ProviderHypothesis;
import com.archsystemsinc.pqrs.model.Speciality;
import com.archsystemsinc.pqrs.model.StatewiseStatistic;
import com.archsystemsinc.pqrs.service.DataAnalysisService;
import com.archsystemsinc.pqrs.service.ParameterLookUpService;
import com.archsystemsinc.pqrs.service.ProviderHypothesisService;
import com.archsystemsinc.pqrs.service.ReportingOptionLookUpService;
import com.archsystemsinc.pqrs.service.SpecialityService;
import com.archsystemsinc.pqrs.service.StatewiseStatisticService;
import com.archsystemsinc.pqrs.service.SubDataAnalysisService;
import com.archsystemsinc.pqrs.service.YearLookUpService;

/**
 * controller class for file upload and insert functionality of provider hypothesis, 
 * state wise statistics, and specialty data
 * 
 * @author Grmahun Redda
 * @since 6/20/2017
 */
@Controller
public class DocumentUploadController {
	
	@Autowired
	private ProviderHypothesisService providerHypothesisService;
	
	@Autowired
	private ParameterLookUpService parameterLookUpService;
	
	@Autowired
	private ReportingOptionLookUpService reportingOptionLookUpService;
	
	@Autowired
	private YearLookUpService yearLookUpService;
	
	@Autowired
	private SpecialityService specialtyService;
	
	@Autowired
	private StatewiseStatisticService statewiseStatisticService;
	
	@Autowired
	private DataAnalysisService dataAnalysisService;
	
	@Autowired
	private SubDataAnalysisService subDataAnalysisService;
	
	@RequestMapping(value = "/admin/documentupload", method = RequestMethod.GET)
	public String documentUploadGet(final Model model, HttpSession session) {		
		
		model.addAttribute("documentFileUpload", new DocumentUpload());
		model.addAttribute("dataAnalysisCategories", dataAnalysisService.findAll());
		model.addAttribute("subDataAnalysisCategories", subDataAnalysisService.findAll());
		
		return "uploadform";
	}
	
	@RequestMapping(value = "/admin/documentupload", method = RequestMethod.POST)
	public String documentUploadPost(
			@Valid@ModelAttribute("documentFileUpload") final DocumentUpload documentFileUpload, final Principal principal,
			final BindingResult result, final HttpServletRequest request, final RedirectAttributes redirectAttributes) throws InvalidFormatException {		
		
		try {
			//
			//documentUploadProvider(documentFileUpload);			
			
			if(documentFileUpload.getProvider().getSize() > 0){
				documentFileUpload.setDocumentTypeId(1L);
				documentUploadProvider(documentFileUpload);
			}else if(documentFileUpload.getSpecialty().getSize() > 0){
				documentFileUpload.setDocumentTypeId(2L);
				specialtyDocUpload(documentFileUpload);
			}else if(documentFileUpload.getStatewise().getSize() > 0){
				documentFileUpload.setDocumentTypeId(3L);
				stateWiseStatistics(documentFileUpload);
			}			
            
			redirectAttributes.addFlashAttribute("documentuploadsuccess","success.import.document");
		}catch (Exception e) {
			System.out.println("Exception in Documents Upload page: " + e.getMessage());	
			e.printStackTrace();
			redirectAttributes.addFlashAttribute("documentuploaderror","error.import.document");			
		}	
		
		//model.addAttribute("documentFileUpload", new DocumentUpload());
		return "redirect:/admin/documentupload";
		
	}

	
   
	public void documentUploadProvider(
			final DocumentUpload documentFileUpload) throws InvalidFormatException, EncryptedDocumentException, IOException {
		
		int totalNumberOfRows = 0;
		int totalProRowsCreatedOrUpdated = 0;
		ArrayList<Object> returnObjects = null;
		
		//try {
			
			if (documentFileUpload.getProvider() != null) {
				
				Workbook providersFileWorkbook = WorkbookFactory.create(documentFileUpload.getProvider().getInputStream());
				Sheet providersFileSheet = providersFileWorkbook.getSheetAt(0);
				Iterator<Row> providersFileRowIterator = providersFileSheet.rowIterator();
                int providersFileRowCount = providersFileSheet.getPhysicalNumberOfRows();
				totalNumberOfRows = providersFileRowCount - 1;
				String stringResult = "";

			
				
				//long yearId =  2;

				while (providersFileRowIterator.hasNext()) 
				{
					Row providersFileRow = (Row) providersFileRowIterator.next();
					
					returnObjects = new ArrayList<Object>();
					
					if (providersFileRow.getRowNum() > 0 && providersFileRow.getRowNum() <= providersFileRowCount)
					{
						System.out.println("ROW - " + providersFileRow.getRowNum());
						Iterator<Cell> iterator = providersFileRow.cellIterator();
						ProviderHypothesis provider = new ProviderHypothesis();
						
						
						while (iterator.hasNext()) 
						{
							Cell hssfCell = (Cell) iterator.next();
							int cellIndex = hssfCell.getColumnIndex();
							
							switch (cellIndex) 
							{
							
							case 1:
								switch (hssfCell.getCellType())
								{
								
				                case Cell.CELL_TYPE_STRING:					                	
				                    stringResult=hssfCell.getStringCellValue();
				                    provider.setYearLookup(yearLookUpService.findByYearName(stringResult));
				                    System.out.println("Year name: " + stringResult);
				                  
				                    break;
								
								}
								break;								
							case 2:
								switch (hssfCell.getCellType())
								{
								
				                case Cell.CELL_TYPE_STRING:	
				                	
				                    stringResult=hssfCell.getStringCellValue();
				                    System.out.println("Reporting option: " + stringResult);
				                    provider.setReportingOptionLookup(reportingOptionLookUpService.findByReportingOptionName(stringResult));
				                    //System.out.println("Reporting option: " + reportingOptionLookUpService.findByReportingOptionName(stringResult).getReportingOptionName());
				                    break;	
								
								}
								break;
	
							case 3:
								switch (hssfCell.getCellType()) 
								{
								
				                case Cell.CELL_TYPE_STRING:	
				                	
				                    stringResult=hssfCell.getStringCellValue();
				                    provider.setParameterLookup(parameterLookUpService.findByParameterName(stringResult));				                   
				                    break;
								
								}
								break;
							case 4:
								switch (hssfCell.getCellType())
								{
								
				                case Cell.CELL_TYPE_NUMERIC:	
				                    provider.setYesValue((int)hssfCell.getNumericCellValue());
				                    break;
								
								}
								break;
							case 5:
								switch (hssfCell.getCellType())
								{
								
				                case Cell.CELL_TYPE_NUMERIC:	
				                    provider.setNoValue((int)hssfCell.getNumericCellValue());
				                    break;
								
								}
								break;
							case 6:
								switch (hssfCell.getCellType())
								{
								
				                case Cell.CELL_TYPE_NUMERIC:	
				                	provider.setYesCount(BigInteger.valueOf((int)hssfCell.getNumericCellValue()));				                   
				                    break;								
								}
								break;
							case 7:
								switch (hssfCell.getCellType())
								{
								
				                case Cell.CELL_TYPE_NUMERIC:	
				                	provider.setNoCount(BigInteger.valueOf((int)hssfCell.getNumericCellValue()));
				                    break;								
								}
								break;
							case 8:
								switch (hssfCell.getCellType())
								{
								
				                case Cell.CELL_TYPE_NUMERIC:	
				                	provider.setYesPercent(hssfCell.getNumericCellValue());
				                    break;								
								}
								break;
							case 9:
								switch (hssfCell.getCellType())
								{
								
				                case Cell.CELL_TYPE_NUMERIC:	
				                	provider.setNoPercent(hssfCell.getNumericCellValue());
				                    break;								
								}
								break;
							case 10:
								switch (hssfCell.getCellType())
								{
								
				                case Cell.CELL_TYPE_NUMERIC:	
				                	provider.setTotalSum(BigInteger.valueOf((int)hssfCell.getNumericCellValue()));				                					                    
				                    break;								
								}
								break;
							case 11:
								switch (hssfCell.getCellType())
								{
								
				                case Cell.CELL_TYPE_NUMERIC:	
				                	provider.setRpPercent(hssfCell.getNumericCellValue());
				                	provider.setDataAnalysis(dataAnalysisService.findById(documentFileUpload.getProviderHypId()));
				                	provider.setSubDataAnalysis(subDataAnalysisService.findById(documentFileUpload.getProviderSubHypId()));
				                	//System.out.println("hyp ID: " + documentFileUpload.getProviderHypId());
				                	//System.out.println("Sub ID: " + documentFileUpload.getProviderSubHypId());
				                	providerHypothesisService.create(provider);				                    
				                    break;								
								}
								break;		
							}


						}
						
						
					}
 
				}
			}			

	}
	
	
	public void stateWiseStatistics(
			final DocumentUpload documentFileUpload) throws InvalidFormatException, EncryptedDocumentException, IOException {
		int totalNumberOfRows = 0;
		int totalProRowsCreatedOrUpdated = 0;
		ArrayList<Object> returnObjects = null;
		
		
			
			if (documentFileUpload.getStatewise() != null) {
				
				Workbook stateStatFileWorkbook = WorkbookFactory.create(documentFileUpload.getStatewise().getInputStream());
				Sheet stateStatFileSheet = stateStatFileWorkbook.getSheetAt(0);
				Iterator<Row> stateStatFileRowIterator = stateStatFileSheet.rowIterator();
                int stateStatFileRowCount = stateStatFileSheet.getPhysicalNumberOfRows();
				totalNumberOfRows = stateStatFileRowCount - 1;
				String stringResult = "";				 
				
				//long yearId =  2;

				while (stateStatFileRowIterator.hasNext()) 
				{
					Row stateStatFileRow = (Row) stateStatFileRowIterator.next();
					
					returnObjects = new ArrayList<Object>();
					
					if (stateStatFileRow.getRowNum() > 0 && stateStatFileRow.getRowNum() <= stateStatFileRowCount)
					{
						System.out.println("ROW - " + stateStatFileRow.getRowNum());
						Iterator<Cell> iterator = stateStatFileRow.cellIterator();
						StatewiseStatistic statewiseStatistic = new StatewiseStatistic();
						
						
						while (iterator.hasNext()) 
						{
							Cell hssfCell = (Cell) iterator.next();
							int cellIndex = hssfCell.getColumnIndex();
							
							switch (cellIndex) 
							{
							
							case 0:
								switch (hssfCell.getCellType())
								{
								
				                case Cell.CELL_TYPE_STRING:					                	
				                    stringResult=hssfCell.getStringCellValue();
				                    statewiseStatistic.setState(stringResult); 
				                    System.out.println("State: " + stringResult);
				                  
				                    break;
								
								}
								break;								
							case 1:
								switch (hssfCell.getCellType())
								{
								
				                case Cell.CELL_TYPE_STRING:
				                	stringResult=hssfCell.getStringCellValue();
				                	statewiseStatistic.setYearLookup(yearLookUpService.findByYearName(stringResult));				                   
				                    break;	
								
								}
								break;
	
							case 2:
								switch (hssfCell.getCellType()) 
								{
								
								case Cell.CELL_TYPE_NUMERIC:
				                    statewiseStatistic.setEpOrGpro((int)hssfCell.getNumericCellValue());
				                    break;
								
								}
								break;
							case 3:
								switch (hssfCell.getCellType())
								{
								
								case Cell.CELL_TYPE_NUMERIC:
				                    statewiseStatistic.setRuralUrban((int)hssfCell.getNumericCellValue());
				                    break;
								
								}
								break;
							case 4:
								switch (hssfCell.getCellType())
								{
								
								case Cell.CELL_TYPE_NUMERIC:
				                    statewiseStatistic.setYesOrNooption((int)hssfCell.getNumericCellValue());
				                    break;
								
								}
								break;
							case 5:
								switch (hssfCell.getCellType())
								{
								
								case Cell.CELL_TYPE_STRING:
									stringResult=hssfCell.getStringCellValue();									
				                    statewiseStatistic.setReportingOptionLookup(reportingOptionLookUpService.findByReportingOptionName(stringResult));
				                    break;								
								}
								break;
							case 6:
								switch (hssfCell.getCellType())
								{
								
								case Cell.CELL_TYPE_NUMERIC:
									 System.out.println("start");
				                    statewiseStatistic.setCount(BigInteger.valueOf((int)hssfCell.getNumericCellValue()));
				                    System.out.println("Count" + hssfCell.getNumericCellValue());
				                    statewiseStatisticService.create(statewiseStatistic);
				                    System.out.println("stop");
				                    break;								
								}
								break;
							default:
								break;
							
							}


						}
						
						
					}
 
				}

			}			

	}
	
	
	public void specialtyDocUpload(
			final DocumentUpload documentFileUpload) throws InvalidFormatException, EncryptedDocumentException, IOException {
		int totalNumberOfRows = 0;
		int totalProRowsCreatedOrUpdated = 0;
		ArrayList<Object> returnObjects = null;
		
		
			
			if (documentFileUpload.getSpecialty() != null) {
				
				Workbook specialtyFileWorkbook = WorkbookFactory.create(documentFileUpload.getSpecialty().getInputStream());
				Sheet specialtyFileSheet = specialtyFileWorkbook.getSheetAt(0);
				Iterator<Row> specialtyFileRowIterator = specialtyFileSheet.rowIterator();
                int specialtyFileRowCount = specialtyFileSheet.getPhysicalNumberOfRows();
				totalNumberOfRows = specialtyFileRowCount - 1;
				String stringResult = "";				 
				
				//long yearId =  2;

				while (specialtyFileRowIterator.hasNext()) 
				{
					Row specialtyFileRow = (Row) specialtyFileRowIterator.next();
					
					returnObjects = new ArrayList<Object>();
					
					if (specialtyFileRow.getRowNum() > 0 && specialtyFileRow.getRowNum() <= specialtyFileRowCount)
					{
						System.out.println("ROW - " + specialtyFileRow.getRowNum());
						Iterator<Cell> iterator = specialtyFileRow.cellIterator();
						Speciality specialty = new Speciality();
						
						
						while (iterator.hasNext()) 
						{
							Cell hssfCell = (Cell) iterator.next();
							int cellIndex = hssfCell.getColumnIndex();
							
							switch (cellIndex) 
							{
							
							case 1:
								switch (hssfCell.getCellType())
								{
								
				                case Cell.CELL_TYPE_STRING:					                	
				                    stringResult=hssfCell.getStringCellValue();
				                    specialty.setPrimarySpeciality(stringResult);
				                    System.out.println("Primary Spec: " + stringResult);
				                  
				                    break;
								
								}
								break;								
							case 2:
								switch (hssfCell.getCellType())
								{
								
				                case Cell.CELL_TYPE_NUMERIC:
				                	specialty.setCount(BigInteger.valueOf((int)hssfCell.getNumericCellValue()));
				                    break;	
								
								}
								break;
	
							case 3:
								switch (hssfCell.getCellType()) 
								{
								
								case Cell.CELL_TYPE_NUMERIC:
									specialty.setPercent(hssfCell.getNumericCellValue());
				                    break;
								
								}
								break;
							case 4:
								switch (hssfCell.getCellType())
								{
								
								case Cell.CELL_TYPE_STRING:
									stringResult=hssfCell.getStringCellValue();										
									specialty.setYearLookup(yearLookUpService.findByYearName(stringResult));									
				                    break;
								
								}
								break;							
							case 5:
								switch (hssfCell.getCellType())
								{								
								case Cell.CELL_TYPE_STRING:									
									stringResult=hssfCell.getStringCellValue();									
									specialty.setReportingOptionLookup(reportingOptionLookUpService.findByReportingOptionName(stringResult));
									specialtyService.create(specialty);
				                    break;								
								}
								break;
							default:
								break;
							
							}


						}
						
						
					}
 
				}

			}			
	}

}
