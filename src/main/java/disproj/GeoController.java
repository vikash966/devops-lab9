package disproj;

import java.io.File;
import java.io.IOException;
import java.net.InetAddress;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class GeoController {
	@RequestMapping("/")
	public String display() {
		return "index";
	}
}

