package com.archsystemsinc.pqrs.controller;

import java.security.Principal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.archsystemsinc.pqrs.model.DataAnalysis;
import com.archsystemsinc.pqrs.model.SubDataAnalysis;
import com.archsystemsinc.pqrs.service.DataAnalysisService;
import com.archsystemsinc.pqrs.service.SubDataAnalysisService;

/**
 * This is the Spring Controller Class for the Hypothesis Screen.
 * 
 * @author Murugaraj Kandaswamy
 * @since 6/26/2017
 */
@Controller
public class DataAnalysisController {
	
	@Autowired
	private DataAnalysisService dataAnalysisService;
	
	@Autowired
	private SubDataAnalysisService subDataAnalysisService;

	@RequestMapping("/dataanalysis")
    public String barChartDisplay(HttpServletRequest request, Principal currentUser, Model model) {
		//model.addAttribute("filter", filter);
		
		final List<DataAnalysis> dataAnalysisList = dataAnalysisService.findAll();
		Map<String, List<SubDataAnalysis>> subDataAnalysisMap = new HashMap<String, List<SubDataAnalysis>>();
		
		for (DataAnalysis dataAnalysis : dataAnalysisList) {
			
		}
		
		model.addAttribute("dataAnalysisList", dataAnalysisList);

        return "dataanalysis";
    }

}